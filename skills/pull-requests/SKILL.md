---
name: pull-requests
description: Fork a repo, park it in the right place, and draft a pull request body (or issue report) in the user's house style, including the review handoff before it is opened. Use whenever forking a repo, drafting a PR description, opening a PR, or proposing a fix to an upstream/third-party repo.
---

# Pull requests

A PR body is a case, not a changelog. The reader is a maintainer deciding whether to trust the diff without reproducing it themselves. Give them the failure, the mechanism, and the honest edges.

## Forking

Forks live in `~/code/forks/<repo>`, one directory per upstream repo, never mixed in with the user's own projects.

```
cd ~/code/forks && gh repo fork <owner>/<repo> --clone --remote
```

That gives `origin` = the user's fork (`mutewinter/<repo>`) and `upstream` = the source repo. Older forks in that directory predate the convention and use other remote names, so run `git remote -v` before pushing rather than assuming.

Work on a branch, never on the default branch. Push to the fork, never straight to a PR.

## Handing off for review

Never open a PR unprompted. Push the branch, then give the user two things, in this order:

1. **A clickable link to review the diff on GitHub**, as a compare against the upstream default branch:
   `https://github.com/<owner>/<repo>/compare/main...mutewinter:<repo>:<branch>`
   Substitute the real default branch if it is not `main`. A plain commit link is a useful extra, not a substitute; the point is to read the delta.
2. **The full PR body, drafted in chat**, in the structure below, exactly as it would be submitted. Not a summary of what it will say.

Open the PR only once they say to.

One PR per change. A tempting adjacent cleanup goes in the body as an offer, not in the diff.

## Structure

Use these headings for a real defect. Drop the ones with nothing to say; a one-line fix can be a few sentences with no headings at all.

- `## Problem` — what a consumer actually sees, as a runnable snippet with the wrong output in a comment. Then why it matters: who hits it, how it presents, why it is easy to misattribute. If it bites an agent rather than a human, say so concretely.
- `## Cause` — the precise mechanism, with the offending lines quoted. Name why the existing tests could not see it. Distinguish the reported cause from the actual one.
- `## Fix` — what changed, in a sentence or two. If a broader alternative exists, name it, say why it is not here, and offer it.
- `## Scope` — `Unchanged:` the behavior you deliberately preserved. Then `Not addressed, deliberately:` anything adjacent you left alone, with the reason.
- `## Tests` — what was added and what it asserts. Say what the test *cannot* prove rather than implying coverage. Give suite counts. Pre-existing failures get called out as pre-existing, and the phrase is "verified by stashing this change and re-running, not inferred".

## Tone

- Terse and specific. No hype, no "comprehensive", no restating the diff in prose.
- Never hard-wrap. One line per paragraph or list item.
- No em dashes.
- Evidence over assertion: paste the real output, cite the upstream issue/PR/commit by number, name versions you actually checked.
- Volunteer the limits. Naming an untested gap reads as competence; implying coverage you do not have does not.
- Offer follow-ups instead of smuggling them in: "say the word and it is one line".

## Title

Match the repo's own commit style, read from its recent history. Common shapes: `Area: imperative description` or `fix(scope): imperative description`.

## Footer

End with a horizontal rule and the attribution line, using the actual model:

```
---

Authored with Claude Opus 5
```
