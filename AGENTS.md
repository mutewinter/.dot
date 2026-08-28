# Dotfiles

Personal macOS dotfiles managed via `install.sh` + GNU stow.

## Structure

- `install.sh` -- single entry point; creates all symlinks. Always add new app config here rather than symlinking manually.
- `home/` -- stow package; everything here mirrors `$HOME`. `install.sh` runs `stow home` to link it.
- `vscode/` -- VS Code config: `settings.json`, `keybindings.json`, `snippets/`, `styles.css`. Cursor symlinks into this directory too when it's installed.
- `_AGENTS.md` -- global agent/AI instructions. `install.sh` chains it to `~/.claude/CLAUDE.md`, `~/.cursor/rules/personal.mdc`, and `~/.codex/AGENTS.md`.
- `_COWORK.md` -- global instructions for Claude Cowork, a trimmed `_AGENTS.md` without the code-specific sections. Cowork stores global instructions on the account with no file backing them, so this is a paste source: copy it whole into Settings > Cowork > Global instructions. Nothing reads it, so `install.sh` does not symlink it.
- `AGENTS.md` (this file) -- repo-specific context. Symlinked to `CLAUDE.md` so Claude Code sees it when working here.
- `skills/` -- agent skills, one subdirectory per skill with a `SKILL.md`. `install.sh` symlinks the whole folder to `~/.agents/skills`; per-agent skill dirs (e.g. `~/.claude/skills/*`) already symlink into `~/.agents/skills/*`, so they pick this up automatically.

## Conventions

- Add new application configs under a named subdirectory (e.g. `lazygit/`, `karabiner/`), then register the symlink in `install.sh`.
- `install.sh` skips existing symlinks, so it's safe to re-run.
- VS Code and Cursor share config from `vscode/`; don't create a separate `cursor/` dir.
