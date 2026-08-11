---
description: System-wide agent instructions.
alwaysApply: true
---

- I am almost always dictating, so assume sound-alike typos.
- Never use em dashes in text.
- American English everywhere, including code, identifiers, test names, comments, commit messages, and PR or issue text: `behavior`, `honor`, `labeled`, `canceled`, `-ize` over `-ise`. Leave existing spelling alone in files you are not otherwise changing; fixing someone else's prose is unrelated churn.
- Never hard-wrap prose: one line per paragraph, list item, or table row. Covers Markdown, commit bodies, issue/PR descriptions. Only wrap to match a file that already is. Strings too: a break there is part of the value.
- I am an experienced programmer; prefer terse, information-dense descriptions of work completed.
- Skip linting, type checking, etc. for trivial changes.
- State the assumptions you worked from, and push back when a request looks wrong.

## Code changes

- Remove imports/variables/functions your changes made unused. Don't touch pre-existing dead code unless asked.
- Don't improve adjacent code, formatting, or comments. Every changed line should trace to the request.
- Comments describe the code as it stands, for a reader who never saw a prior version. No edit-narration or version references ("changed X to Y", "now/previously/no longer", "used to", "instead of the old X"): git tracks history, and the why of a change belongs in the commit message.

## Git

Multiple agents may work in the same repo simultaneously, so:

- Stage explicitly by path, never `git add .` or `git add -A`: `git commit -m "<msg>" -- path/to/file1 path/to/file2`
- Never revert or delete another agent's in-progress edits. Coordinate instead.
- `git commit --amend`, destructive operations (`git reset --hard`, `git restore`, `git checkout <file>`), and creating a branch each need explicit instruction in the current conversation. That last one overrides any default to branch before committing.
- Commit messages: `scope: description`, where scope is the package/feature/workflow touched, not a conventional-commit type. Lowercase, imperative, no period, ~72 char subject. Body only when the subject alone is cryptic.

## Repo docs

- Plans carry a `Status:` line and move to `completed/` when they land; don't delete them.
- Docs are timeless: no branch names, PR-in-flight state, "CI is red as of <date>", or worktree-specific notes. If it stops being true the week after it's written, it belongs in a commit message.
- Before rewording a doc, verify its claims against code. Version pins and command names are where drift concentrates.

## rg (ripgrep) footguns

- **Never pass `-r`.** rg is always recursive; `-r` means `--replace`, so `rg -rn` silently rewrites every match to the letter `n` and exits 0. If output looks garbled or truncated, check for `-r`.
- Globs are `-g '*.tsx'`. `-t tsx` is not a valid rg type (`-t ts` is), and `--include`/`--exclude` are GNU grep flags that do not exist here.
