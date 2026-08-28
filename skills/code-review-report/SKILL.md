---
name: code-review-report
description: Review a range of recent work in the current repo and land the findings as an uncommitted markdown file at the repo root, ordered by severity. Use when the user asks for a code review of recent commits, a branch, a diff, or "the last couple of days", or wants a written review they can work through afterwards. Not for reviewing a GitHub PR in place, which posts comments instead.
---

# Code review report

A review whose deliverable is a file the user works through later, not a comment thread and not a chat message that scrolls away. Ordered by severity, every finding citing `file:line`, nothing in it the user has to re-derive.

Not the same job as `/code-review`, which audits a GitHub PR and posts a comment on it. Reach for this one when the work is local, the range is a stretch of history rather than a PR, or the user wants something to read.

## Scope the range before reading anything

Name the exact range and put it in the file. Never review "recent work" without pinning it to two commits.

- "the last couple of days" means dated, not counted: `git log --since="<date>" --pretty=format:'%h %ad %an %s' --date=format:'%Y-%m-%d %H:%M'`, then take the last commit before the window as the base.
- If the user has reviewed before, ask what the previous review covered, or find the prior report file, and start where it stopped. Do not re-raise what it already raised.
- Get the shape before the substance: `git diff --numstat <base> HEAD | sort -k1 -rn | head -60`. Churn ranking is what tells you which twenty files out of two hundred to actually read.

Say the range, the commit count, and the line counts in the report's first line. A reader who cannot tell what was in scope cannot tell what was missed.

## Read the repo's own calibration first

Before forming an opinion, look for `REVIEW.md`, `CONTRIBUTING.md`, `CLAUDE.md` / `AGENTS.md` at the root and in the directories the diff touched. A repo that has written down what it considers important has already done half the prioritization, and a review that ignores it is a review of a different codebase.

Where the repo names its own severity vocabulary, its risk categories, or things it explicitly does not want reported, follow that and say in the report that you did. The rubric below is the default for a repo that says nothing.

## Severity

Four levels. Put the key in the report so the user does not have to remember it.

- **S1 — Fix now.** Privacy, data loss, security, or correctness, and it is live in code that ships. Something is wrong for real users right now.
- **S2 — Fix soon.** A real user-visible defect with a bounded trigger, or a hardening gap whose fix is cheap. Not on fire, will be.
- **S3 — Worth doing.** Design or structure that will cost more later than it costs now. This is where refactors go.
- **S4 — Note only.** Recorded so the next review does not rediscover it. No action implied.

Two rules that matter more than the labels:

**Severity is about consequence, not about how interesting the finding is.** A one-line fix that stops a URL leaving the machine outranks a beautiful structural observation about three files.

**Say why it is that level, not just that it is.** "S1 because the mechanism predates the window but the blast radius went from a few cards to every link in every transcript" is a sentence the user can argue with. "S1" alone is not.

Do not pad. A review with two S1s and one S3 is a better review than the same one with eleven S4s bulking it out.

## Verification bar

The failure mode of a written review is a confident paragraph about something that does not happen.

- Cite `file:line` for every behavioral claim, and trace the implementation rather than the doc comment. Doc comments describe intent, and the gap between the two is often the finding itself.
- Prove it when you can. A throwaway test that renders the case and prints the actual value is worth more than any amount of reasoning, and it takes two minutes: copy the existing test file next to itself so you inherit its mocks and setup, add the case, run just that file, **delete the copy**. Say "verified by probe" in the finding and quote what came back.
- When you traced it statically and did not run it, say so in that finding. Do not launder a reading as a reproduction.
- Kill your own hypotheses first. Several plausible findings die on the second check: the grep was truncated, the flag was wired after all, the second implementation delegates to the first. Check before writing, not after.
- Prefer one finding on the root cause to one per call site. If three surfaces disagree, the finding is the missing shared policy, and the three are its symptoms.

## Do not report

- Anything the repo's own checks enforce: formatting, lint, type errors, spelling, lockfile policy. Assume CI runs.
- Pre-existing issues on lines the range did not touch, unless the change is what made them reachable. When a mechanism predates the window but the change widened its reach, that is in scope, and say exactly that.
- Vendored code, generated files, submodules, lockfiles, version bumps in release commits.
- Documentation style. Do report a doc whose factual claims contradict the code in the same range.
- "Add more tests" as a general wish. A missing test is a finding when the changed behavior is important and the existing test setup could observe it, and then name the case.

## Refactors

The user usually wants these, and they belong at S3 unless they are load-bearing for an S1 or S2.

Look for the structural cause behind the defects you already found rather than surveying the codebase for improvements. Three allow-lists that disagree, two state machines kept in sync by a matched constant, one policy expressed in four places: those earn a finding because a defect already came out of them. A file that is merely long does not.

Give the shape of the fix and its rough size. "One exported predicate both callers use, about forty lines" is actionable. "Consider consolidating" is not.

## The file

Write it to the repo root, uncommitted, named `CODE-REVIEW-<YYYY-MM-DD>.md`. Leave it untracked. Do not commit it, do not add it to `.gitignore`, do not delete a previous one.

Structure:

1. **Title and scope.** Range, commit count, diffstat, what calibration you followed.
2. **Tally and areas.** `4 fix-now/soon, 3 worth doing, 4 notes`, then the subsystems touched, in one line each.
3. **An honest overall read.** Two or three sentences on the state of the work. If it is good, say so plainly and say what makes it good. A review that opens with faint praise before the findings reads as a formality; one that says nothing at all reads as a machine.
4. **Severity key**, as a small table.
5. **Findings**, S1 first, numbered continuously across levels so they can be referred to by number. Each one: a heading that states the defect in a sentence, the mechanism with citations, the concrete failure sequence, and the fix as code where a code block is shorter than the prose would be.
6. **Confirmed tradeoffs.** The deliberate decisions you checked and found correct, one line each. This is the most reused part of the report: it stops the next review re-litigating the same six things, and it shows the user which of their explanations actually landed.

Findings link as markdown so they are clickable: `[update.ts:322](apps/studio/src/electron-main/lib/update.ts:322)`.

## Finishing

Give the user the path and the headline in chat: what the S1 is and what it costs. Do not paste the report back. The file is the deliverable, and repeating it is how the file stops being read.
