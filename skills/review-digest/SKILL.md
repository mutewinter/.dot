---
name: review-digest
description: Build a one-page review of a range of commits the user did not read as they landed, grouped by concern, with every commit tied to the Claude Code session that made it. Use when the user asks to review recent work, a merge, a branch, a release, "what landed while I was away", "since my last review", one subject's commits over a stretch of time, or wants a review digest; not for a GitHub PR thread or a findings-only code review (code-review-report).
---

# Review digest

The reader owns the repo, and agents wrote the commits while they were away. The page lets them glance at the whole range, then drop into any part of it: concerns as tiles across the top, topics as cards within each concern, every commit one click from its message, its ask and its session, and a table of the sessions that did the work, each with a Resume button.

Most of the page is mechanical. Scripts read git and the session transcripts: commits, line counts, files, bodies, the ask before each commit, and each session's title, branch, checkout, span, model and prompt count. The agent writes only the words: the title, a summary, the concerns, and short topics that cite commits. Keep it that way, and keep the writing short.

## 1. Pin the range

Always two commits, stated on the page.

- **Since the last review** (the default): `refs/review/last..<branch tip>`. If `refs/review/last` does not exist, ask for a starting point or take the last release tag.
- **A merge commit `M`**: base `M^1`, head `M`.
- **A release**: the previous tag to the tag.
- **A span of time** ("today", "the last two days"): `git rev-list -1 --before=<when> <branch>` as the base.
- **One subject** ("the ChatGPT plan work this week"): a span of time plus `--grep` on subjects.

Pin the head to a SHA rather than a moving branch name, so the page can be rebuilt.

## 2. Collect

```bash
python3 <skill>/scripts/collect.py <base> <head> [--grep REGEX] --out <work>
```

`<work>` defaults to `~/.cache/review-digest/<repo>/<base>-<head>/`; name it for the range instead (`since-beta-42`, `chatgpt-plan-week`). Writes `collect.json` and `summary.md`: areas by lines changed, dependency changes, and every commit oldest first, marked `[no session]` when no transcript made it. The transcript join matches each commit by the `[branch sha]` line git prints, then by its subject inside a `git commit` call; expect 85 to 95% coverage, with release-script, hand-made and other-machine commits missing.

## 3. Write concerns.json

Read `summary.md`, and the bodies of commits whose subjects do not explain themselves. Write `<work>/concerns.json` (the format is in `scripts/build.py`'s docstring):

- `title`: the subject, plainly (`Since the 2.0 merge`, `ChatGPT plan, the last week`, `Today, Oct 3`).
- `summary`: two or three sentences on what the range did as a whole.
- `concerns`: 3 to 6 for a day, up to 10 for weeks. Each is a subject a person would recognize (`Finder and files`, `Tabs and browsing`), never a directory. Give each:
  - `icon`: a Phosphor regular icon name that names its subject (`folders`, `browsers`, `key`), never its genre (no gear for settings, no lightbulb for ideas).
  - `gist`: one line.
  - `paths`: prefixes or globs that claim the commits no topic cites.
- `topics` in each concern: one card per thing that happened. `head` is eight words at most, `line` one sentence, `shas` the commits behind it. Cite every commit that belongs to a topic; uncited commits still appear, under "more commits" at the end of their concern. `note` is optional detail that goes only into the card's Ask prompt.

Write from what the commits and their bodies say. Do not invent motives or alternatives; the reader can open the session for those.

**For a large range** (more than about 150 commits), write the concerns with `paths` and no topics, then:

```bash
python3 <skill>/scripts/build.py <work> --briefs
```

That writes `<work>/briefs/<id>.md` per concern: the commits landing in it with their bodies, asks, sessions and files. Give each brief to its own subagent with `references/concern-brief.md`, to write `<work>/topics/<id>.json`. Check two or three cited SHAs per concern when they return.

## 4. Build and render

```bash
python3 <skill>/scripts/build.py <work>
python3 <skill>/scripts/render.py <work>/data.json ~/visual-answers/<YYYY-MM-DD>-review-<name>.html
```

`build.py` warns about any cited SHA outside the range, and prints how many commits landed in each concern; a concern far bigger than its topics suggest usually means its `paths` are too broad. Commits no concern claims go into "Everything else". Do not open the page; a viewer picks up new files in `~/visual-answers` on its own. Give the path and the summary in chat, in a few lines.

## 5. Afterwards

- **Ask an agent.** Each card's button copies a prompt naming the range, concern, topic and its commits; the user pastes it and adds their question. Treat it as a task: confirm against the code and the session, then answer or propose the change.
- **Resume.** Each session's button copies `claude --resume <id>`, run from that session's checkout.
- **Reading the code in lazygit** (optional): `build.py` also writes `<work>/groups.json`, the concerns as path groups. `python3 <skill>/scripts/review_ref.py <work>/groups.json --worktree <repo-parent>/<repo>-review` turns each into one synthetic commit on `refs/review/<name>`, so `lazygit -p <worktree> log` shows one concern at a time. No branch is created and nothing is pushed.
- **When the review is done**: `git update-ref refs/review/last <head>`, so the next digest starts there.
