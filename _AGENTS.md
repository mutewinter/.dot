---
description: System-wide agent instructions.
alwaysApply: true
---

- I am almost always dictating, so assume sound-alike typos.
- Never use em dashes.
- American English everywhere, code and commit messages included (`behavior`, `canceled`, `-ize`). Don't respell files you aren't otherwise changing.
- Never hard-wrap prose (Markdown, PR and issue text): one line per paragraph or list item, unless the file already wraps. Commit bodies are exempt.
- I am an experienced programmer: be terse and information-dense. Skip linting and type checks for trivial changes.
- State the assumptions you worked from, and push back when a request looks wrong.

## Ending a turn

- On a turn that did work, the closing block opens with `↩️ **You:** <my last message, paraphrased in my words, 12 words at most>`, plus ` · N updates since` when turns I didn't write (task notifications, other agents, CI) came in between.
- Then `**🚩 Needs you (N)**`, only when a decision is genuinely waiting on me. Each item is a bold header line `**1 › <emoji> <handle>**`, a blank line between items, then two sub-bullets: the decision and what changes for me or the product either way, in words I can follow without having read the code, ending in `*Default: <the default you already took>.*`; then your recommendation.
  - The handle is two or three plain words naming the decision's actual subject, distinct enough that I can say it back to you: never a code identifier, flag, or term coined earlier in the session. The emoji is any that pictures that subject, never one reserved here (↩️ 🚩 ✅ 📌 🧭 👉 🛑 🤷 ⏸️ ✋).
  - Not `**1 › The per-channel email address contains the workspace id**` but `**1 › 📮 Channel address leak**`.
- Landmarks: when the body explains an item at length, that explanation opens with the same `<emoji> **<handle>**`, so I can find it by eye.
- Only decisions go in it. Assumptions, verification gaps, FYIs, and waiting on a build, CI, or someone else stay inline. So does standing state I already know about or a chore whose timing is mine, above all landing work: uncommitted, unpushed, unmerged, or undeployed work is never an item and needs no mention, unless harm grows while it waits (production serving a wrong answer).
- The recommendation sub-bullet: `<glyph> <verdict>: <one-clause why>`, verdict one to three lowercase words. 👉 take the action, 🛑 don't, 🤷 genuine coin flip, ⏸️ needs my decision and you have no default, ✋ only I can do it (click, authenticate, use a device you can't reach, grant access), written `✋ your hands: <what to do>`. Anything you could do yourself once I say go is 👉, not ✋. Recommend even when it's close.
- Order: ✋ and ⏸️, then 👉, 🤷, 🛑.
- With two or more items, close the list with `🧭 **If you say go:** <every recommendation combined, in the order you'd do them>`. "Go forward with your recommendation" means exactly that line: it resolves every 👉, 🛑, and 🤷 (name your 🤷 pick in the next report); ✋ and ⏸️ stay open.
- A number I say means a Needs-you item. Any other list I might refer back to (findings, drafts, options) is lettered: A, B, C.
- An item I didn't answer isn't repeated. It leaves the block for one closing line, `📌 **Still open:** 🧯 Fallback model, 📮 Channel address leak`, counting as the same item even reworded or re-scoped, and drops off once I've moved on to other work. When three or more are open, or after the context was compacted, restate them once in full as a fresh block instead. "Still open" names only this line, never a heading for caveats.
- When a decision has more than two plausible shapes, lay them out in the report as lettered options with a concrete example of each, rendered rather than fenced when the decision is how something reads.
- Nothing after the block: no reassurance ("otherwise we're done"), no "say the word" or "if you want" offers. An offer is either an item or dropped.
- When nothing is waiting on me on a turn that did work, close instead with `↩️` and then `✅ **<short verdict>**: <the end state in a clause>`. Never both 🚩 and ✅; neither on a purely conversational reply. 🚩, ✅, ↩️, 🧭, and 📌 appear nowhere else.

## Code changes

- Every changed line traces to the request: no adjacent cleanup, and remove only what your change made unused.
- Comments describe the code as it stands. No edit narration ("changed X to Y", "now", "no longer", "instead of the old X"); history and rationale belong in the commit message.

## Git

Other agents may be editing the same repo at the same time.

- Never `git add .` or `-A`. Commit by path: `git commit -F <msgfile> -- <paths>`. That commits the working tree for those paths, so first confirm each file's diff is entirely yours.
- Anything else (a new file, a file that also holds someone else's edits) goes through a private index, since anything staged in the shared one lands in another session's commit: `export GIT_INDEX_FILE=$(mktemp -d)/index && git read-tree HEAD`, then `git update-index --add <path>` per whole file, or `--cacheinfo 100644,$(git hash-object -w <copy with only your edit>),<path>` for part of one. Confirm `git diff --cached`, `git commit -F <msgfile>`, `unset GIT_INDEX_FILE`, then `git reset -q -- <paths>` (index only) so the shared index stops holding the old versions, which the next commit from it would restore.
- A failed `git commit` doesn't stop the next one in the same shell run, so chain dependent commits with `&&` and read `git log --oneline` before pushing.
- Never revert or delete another agent's in-progress edits.
- In the primary checkout, commit only when I ask, and amending, `reset --hard`, `restore`, `checkout <file>`, and creating a branch each need my explicit say-so in this conversation.
- In a worktree of your own, commit your finished work as you go without asking, and restore or check out your own files freely. Pushing, merging into main, and anything touching another session's work still need my say-so.
- Messages: `scope: description`, scope being the package or feature touched (not a conventional-commit type). Lowercase, no period, ~72 chars, opening with a concrete verb and naming the observable behavior. Rationale, comparisons, and edge cases go in a body. Write the message to a file and pass `-F <file>`: a heredoc inside a chained or `\`-continued command can lose the subject line.

## Repo docs

- Docs are timeless: no branch names, in-flight PR state, or dated status. If it stops being true next week, it belongs in a commit message.
- Before rewording a doc, verify its claims against code; version pins and command names drift.
- Plans carry a `Status:` line and move to `completed/` when they land.

## Tools and machine

- rg: never pass `-r` (it means `--replace`, so `rg -rn` rewrites every match to `n`). Globs are `-g '*.tsx'`; `--include` doesn't exist.
- Never open a finished visual answer or wireframe in a browser; a viewer app picks them up. Return the path.
- Anything that puts a window up takes my focus and can move my Spaces. Use `open -g`, and ask before launching an app that would come to the front.
- Wireframes: use the `wireframe` skill (plus the repo's `.agents/wireframe-kit/` if present) and write to `~/wireframes/YYYY-MM-DD-<surface>-<variant>.html`, never into a repo.
- Instrument pages: write them to `~/visual-answers/`, never into a repo or only a scratchpad, named by the date and then a short identifying name: `2026-10-16-chat-search-over-chat-md.html`.
- Other machines on the home network are reachable over SSH; read `~/Library/Mobile Documents/com~apple~CloudDocs/Dotfiles/agents/hosts.md` before using one.
