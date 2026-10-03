# Brief for one review group

You are preparing one group of a review digest for the repo's owner, a very experienced developer who did not read these commits as they landed. Agents wrote them; their question is not "is there a typo" but **"did the agent make a call here I would have made differently, and what does this lock in?"** Your output is read in about two minutes per group, so every line has to earn its place.

Read-only. Do not edit, commit, check out, or create branches. Scratch files go in the scratch directory you are given.

## Inputs you are given

- The group brief (`<id>.md`): files with status, line counts, path-based signals (schema, migration, rpc, ipc, on-disk, shared-types, sandbox, build) and newly exported names; the commits that touched those files, oldest first, each with its body and **the human ask that led to it**, recovered from the session transcript, plus that transcript's path and line.
- The review commit for the group: `git diff <prev> <sha>` shows exactly this group's net change. Use `-- <path>` to read one file; never dump the whole diff.
- The repo at its current tip, for plans (`docs/plans/active/`), decisions (`docs/decisions/`), architecture maps (`docs/architecture/`), and `REVIEW.md`.

## How to work

1. Skim the commit list for the shape of the story: what was built, what was rewritten, what was reverted. The most-touched files are where the design moved around.
2. Find the **decisions**: choices where another reasonable engineer could have gone a different way. A data shape, where state lives, who owns a lifecycle, a new seam or abstraction, a dependency, a convention other code will copy, something deleted. Not styling, not copy.
3. For each decision, find the evidence. Prefer, in order: the commit body, the transcript (open it at the given line and read backwards for the plan, the alternatives raised, what the user pushed back on), then the code. Read the transcript slice with a short script; do not load whole files.
4. **Rejected alternatives must be real.** Only list one if a commit body or transcript shows it was considered. Otherwise write `none recorded`. Never invent a plausible alternative and present it as rejected.
5. For each decision, name what it **commits the codebase to**: on-disk shapes, schema versions, RPC or IPC contracts, invariants other code must keep, conventions that will be copied.
6. **Two steps down.** Check the decisions against what is planned: `docs/plans/active/*.md` (read the Status lines and goals), open items in architecture docs, and anything the transcripts say is coming. Name concrete collisions: "plan X needs Y, and this decision makes Y harder because Z". This is the most valuable part of your output. If nothing collides, say so in one line rather than padding.
7. Tests: note tests deleted, assertions loosened, or `skip`/`todo` added in this group (grep the diff for removed `expect(` lines and `.skip`). Say whether the loosening was explained.
8. Findings are secondary and kept separate: at most five, each with `file:line` and S1 to S4 severity (S1 fix now, S2 fix soon, S3 worth doing, S4 note). Say "traced, not run" unless you ran something. Skip anything lint or types would catch.
9. Write 2 to 4 questions the owner should be able to answer about this group if they understand it. Medium difficulty, about behavior or design, not trivia.

## Output

Write JSON to `<scratch>/groups/<id>.json` and reply with only the path and a one-line headline. Shape:

```json
{
  "id": "g01",
  "title": "short noun phrase for the group",
  "summary": "2 to 4 sentences: what this part of the codebase became in this range, in plain words.",
  "asks": ["Paraphrased user ask that drove the work (date)"],
  "decisions": [
    {
      "decided": "the choice, one sentence",
      "rejected": ["alternative (why), only if recorded"],
      "commits_to": ["durable thing others must keep honoring"],
      "evidence": "sha, file:line, or transcript date",
      "basis": "recorded | inferred"
    }
  ],
  "two_steps_down": [{ "concern": "what gets harder", "against": "docs/plans/active/x.md or other source", "why": "one sentence" }],
  "hotspots": [{ "path": "file", "note": "touched by N commits; what kept changing" }],
  "tests": "one or two sentences on test changes, or 'nothing notable'",
  "questions": ["question"],
  "findings": [{ "severity": "S2", "where": "path:line", "text": "defect and failure sequence, one or two sentences", "basis": "traced, not run" }],
  "read_order": ["up to 8 paths, foundations first: types and schemas, core logic, call sites, UI, tests"],
  "key_commits": [{ "short": "abc1234", "subject": "..." }]
}
```

Limits: at most 7 decisions, ordered by how much they lock in. Plain words, American English, no em dashes. Mark inference as inference.
