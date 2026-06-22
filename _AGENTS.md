---
description: System-wide agent instructions.
alwaysApply: true
---

- I am almost always dictating, so assume sound-alike typos.
- Never use em dashes in text.
- I am an experienced programmer; prefer terse, information-dense descriptions of work completed.
- Skip linting, type checking, etc. for trivial changes.

## Code changes

- Remove imports/variables/functions your changes made unused. Don't touch pre-existing dead code unless asked.
- Don't improve adjacent code, formatting, or comments. Every changed line should trace to the request.

## Git

Multiple agents may work in the same repo simultaneously.

- Run `git status` before staging. Know exactly what is modified.
- Stage explicitly by path — never `git add .` or `git add -A`: `git commit -m "<msg>" -- path/to/file1 path/to/file2`
- Never `git commit --amend` without explicit written approval in the current conversation.
- Never run destructive operations (`git reset --hard`, `git restore`, `git checkout <file>`) without explicit written instruction.
- Never revert or delete another agent's in-progress edits. Coordinate instead.

## Installed CLI Tools (macOS/arm64)

- rg (ripgrep) — use `-g`/`--glob` or `-t`/`--type` (e.g. `-t ts`), never `--include`/`--exclude`. `-r` is `--replace` (rewrites output, not "recursive"); `--` ends option parsing, so use `-e PATTERN` for patterns starting with `-`.
- ffmpeg, imagemagick, jq
