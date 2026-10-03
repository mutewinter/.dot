---
name: review-digest
description: Build a decision-first review of a range of commits the user did not read as they landed. Groups the change by concern, recovers each commit's ask and reasoning from the Claude Code session that wrote it, names what each decision commits the codebase to and what it makes harder in the plans on file, and turns every group into one synthetic commit so lazygit, hunk or an editor shows exactly that group. Use when the user asks to review recent work, a merge, a branch, "what landed while I was away", "since my last review", or wants a review digest; not for a GitHub PR thread or a findings-only code review (code-review-report).
---

# Review digest

The reader is the owner of the repo. Agents wrote the commits; they walked away while the commits landed. They are not hunting typos. They want to catch **a call they would have made differently** and **what it locks in**, and only then read code, in the tool they already use.

So the digest leads with decisions, keeps findings folded at the bottom of each group (findings shown first narrow a reviewer's attention to what was flagged), and hands them targeted code views instead of one enormous diff.

## 1. Pin the range

Always two commits, stated in the output.

- **Since the last review** (the default): `refs/review/last..<branch tip>`. If `refs/review/last` does not exist, ask for a starting point or take the last release tag.
- **A merge commit `M`**: base `M^1`, head `M`. The merged branch's commits are `M^1..M`.
- **A named span** ("today", "since beta.40"): resolve to commits and say which.

## 2. Collect

```bash
python3 <skill>/scripts/collect.py <base> <head> --out <work>
```

`<work>` defaults to `~/.cache/review-digest/<repo>/<base>-<head>/`. Writes `collect.json` and `summary.md`: areas by lines changed, with path signals (schema, migration, rpc, ipc, on-disk, shared-types, sandbox, build), new files, newly exported names, dependency changes, and every commit with the human ask behind it.

The transcript join finds the session that made each commit, first by the `[branch sha]` line git prints, then by the subject inside a `git commit` tool call. The second path matters: agents often commit with `-q`, and work rebased in from a worktree has a new SHA. Expect 80 to 90% coverage; release-script and hand-made commits have no session.

## 3. Group by concern, in reading order

Read `summary.md` and write `<work>/groups.json` (format in `scripts/review_ref.py`). Aim for 5 to 9 groups for a day or two of work, 10 to 14 for a merge of weeks. Order them the way the code should be read: on-disk shapes, schemas and migrations first; then core logic; then the process boundary (RPC, IPC, main process); then UI; then tests, tooling and docs. Removals get their own group.

Path entries are prefixes, or globs when the directory is flat (`src/lib/migrate*`). The longest match wins, so a broad prefix plus a few specific globs works. Unclaimed files fall into a final "Everything else" group; keep it small and say what is in it.

## 4. Build the review commits

```bash
python3 <skill>/scripts/review_ref.py <work>/groups.json --worktree <repo-parent>/<repo>-review > <work>/ref.json
python3 <skill>/scripts/group_inputs.py <work>/collect.json <work>/ref.json <work>/inputs
```

Each group becomes one commit on `refs/review/<name>`: base plus the head version of that group's files, chained in reading order, and the script checks the final tree equals the head tree. No branch is created and nothing is pushed. `--worktree` checks the chain out detached so `lazygit -p <worktree> log` opens straight onto it; reuse the same worktree path across digests. `group_inputs.py` writes one brief per group.

## 5. Write each group

Follow `references/group-brief.md`. For more than three groups, give each group to its own subagent with that brief, the group's input file, the repo path, the range, and where to write `<work>/groups/<id>.json`. Subagents are read-only.

When they return, check the output before trusting it: open two or three cited SHAs or `file:line`s per group, and drop any "rejected" alternative without evidence. A subagent that invents a plausible rejected alternative is the main failure mode of this skill.

## 6. Assemble and render

Write `<work>/meta.json` yourself, after reading every group:

- `title`: the subject, e.g. `2.0 merge into main` or `Review since beta.41`.
- `overview`: two or three short paragraphs. What the range did as a whole, and the two or three decisions across groups most worth their attention.
- `start_here`: three to six items, each pointing at a group with one sentence, ranked by what is hardest to undo.
- `footer`: range, how commits were joined to sessions, what was traced versus run.

The first command rebuilds the review commits with each group's summary and decisions as its message, so lazygit's log reads as the digest; the files are identical, only the SHAs change.

```bash
python3 <skill>/scripts/review_ref.py <work>/groups.json --worktree <same path> --writeups <work>/groups > <work>/ref.json
python3 <skill>/scripts/assemble.py <work>/collect.json <work>/ref.json <work>/groups <work>/meta.json <work>/digest.json
python3 <skill>/scripts/render.py <work>/digest.json ~/visual-answers/<YYYY-MM-DD>-review-<name>.html
```

Do not open the page; a viewer picks up new files in `~/visual-answers` on its own. Give the path, the commands for lazygit and hunk, and the start-here list in chat, in a few lines.

## 7. Afterwards

- **They dictate objections.** Each Disagree button copies a prompt naming the group, review commit and decision; they paste it and keep talking. Treat that as a task: confirm the decision in the code, then propose the change.
- **"Walk me through group N."** They run `hunk show <sha>` in a terminal. Drive the live session with the hunk skill (`hunk skill path` prints it): navigate files in the group's read order, `highlight add` the exact lines that carry each decision, and `comment apply` a short note per decision. Read their notes back with `hunk session review --include-notes`.
- **When they say the review is done**: `git update-ref refs/review/last <head>`, so the next digest starts there. Old `refs/review/<name>` refs can be deleted with `git update-ref -d`.
