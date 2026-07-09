---
description: System-wide agent instructions.
alwaysApply: true
---

- I am almost always dictating, so assume sound-alike typos.
- Never use em dashes in text.
- I am an experienced programmer; prefer terse, information-dense descriptions of work completed.
- Skip linting, type checking, etc. for trivial changes.

## Before coding

- State assumptions explicitly. If a request is ambiguous or has multiple interpretations, surface them and ask rather than guessing silently. Present tradeoffs and push back when warranted.
- Turn vague asks into concrete, checkable success criteria before starting, then work toward them. On trivial tasks, use judgment and skip the ceremony.

## Code changes

- Remove imports/variables/functions your changes made unused. Don't touch pre-existing dead code unless asked.
- Don't improve adjacent code, formatting, or comments. Every changed line should trace to the request.
- Comment only when the *why* is non-obvious (rationale, invariant, gotcha, tradeoff). Don't restate what the code already says: a good comment adds precision or intuition the code can't express ("why, not what"), it doesn't narrate it. Prune redundant/obvious comments, but keep an existing "why" comment unless your change makes it wrong.
- Write "timeless" comments: describe the code as it stands, for a reader who never saw a prior version. No edit-narration or version references ("changed X to Y", "per your request", "now/previously/no longer", "used to", "rather than/instead of the old X"). Those are "journal comments"; git already tracks history, and the why of a *change* belongs in the commit message, not the code. Quick test: if a comment only makes sense to someone who knows what the code used to be (or what you almost wrote instead), rewrite it as the positive reason.

## Git

Multiple agents may work in the same repo simultaneously.

- Run `git status` before staging. Know exactly what is modified.
- Stage explicitly by path — never `git add .` or `git add -A`: `git commit -m "<msg>" -- path/to/file1 path/to/file2`
- Never `git commit --amend` without explicit written approval in the current conversation.
- Never run destructive operations (`git reset --hard`, `git restore`, `git checkout <file>`) without explicit written instruction.
- Never revert or delete another agent's in-progress edits. Coordinate instead.
- Never create new branches unless explicitly instructed.
- Commit messages: `scope: description` (e.g. `dx: drop eslint --cache from lint scripts`). Scope is the package/feature/workflow touched, not a conventional-commit type — no `feat:`/`fix:`/`chore:`. Description: lowercase, no period, imperative, informative, ~72 char subject. Add a bullet-list body only when the subject alone is cryptic.

## Installed CLI Tools (macOS/arm64)

- rg (ripgrep):
  - Always recursive by default — **never add `-r`**. `-r` means `--replace`, so `rg -rn` silently rewrites every match to the letter `n` (exit 0, no warning). If rg output looks garbled or truncated, check for `-r` in the command.
  - File globs: `-g '*.tsx'` or `-g '*.ts'` — `-t tsx` is not a valid rg type; `-t ts` is. Never `--include`/`--exclude` (those are GNU grep flags, not rg).
  - Other flags: `-n` (line numbers), `-l` (files only), `-i` (case-insensitive), `-e PATTERN` (needed when pattern starts with `-`); `--` ends option parsing.
- ffmpeg, imagemagick, jq
