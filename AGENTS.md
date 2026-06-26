# Dotfiles

Personal macOS dotfiles managed via `install.sh` + GNU stow.

## Structure

- `install.sh` -- single entry point; creates all symlinks. Always add new app config here rather than symlinking manually.
- `home/` -- stow package; everything here mirrors `$HOME`. `install.sh` runs `stow home` to link it.
- `cursor/` -- Cursor and VS Code shared config: `settings.json`, `keybindings.json`, `snippets/`, `styles.css`. Both editors symlink into this directory.
- `_AGENTS.md` -- global agent/AI instructions. `install.sh` chains it to `~/.claude/CLAUDE.md`, `~/.cursor/rules/personal.mdc`, and `~/.codex/AGENTS.md`.
- `AGENTS.md` (this file) -- repo-specific context. Symlinked to `CLAUDE.md` so Claude Code sees it when working here.

## Conventions

- Add new application configs under a named subdirectory (e.g. `lazygit/`, `karabiner/`), then register the symlink in `install.sh`.
- `install.sh` skips existing symlinks, so it's safe to re-run.
- Cursor and VS Code share config from `cursor/`; don't create a separate `vscode/` dir.
