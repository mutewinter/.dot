# Dotfiles

Personal macOS dotfiles managed via `install.sh` + GNU stow.

## Structure

- `install.sh` -- single entry point for every symlink. Add new app config under a named subdirectory (e.g. `lazygit/`, `karabiner/`) and register it here rather than symlinking manually.
- `home/` -- stow package mirroring `$HOME`.
- `_AGENTS.md` -- global instructions for coding agents, and the source of truth for every shared rule. `install.sh` chains it to `~/.claude/CLAUDE.md`, `~/.cursor/rules/personal.mdc`, and `~/.codex/AGENTS.md`, so edits go live without further steps.
- `_CHAT.md` -- the same instructions for chat apps (Claude, including Cowork, and ChatGPT): `_AGENTS.md` with the code, git, and tooling rules removed and the rest made tool-neutral. Those apps keep instructions on the account with no file backing them, so nothing reads this file and `install.sh` does not link it; it is a paste source. After changing a rule in `_AGENTS.md`, carry the change here if it applies outside code, then paste the whole file into each app's account-level instructions.
- iCloud Drive `Dotfiles/` (`$DOT_PRIVATE`) -- private counterpart to this public repo, for config that names people or is otherwise personal. Laid out by app like the repo (e.g. `Dotfiles/handy/cleanup-prompt.md`); app scripts read from it when it exists and skip that piece when it doesn't. Secrets such as API keys and licenses go in neither place.
- `macos/profile.sh` -- prints the keyboard profile, `desktop` (Model 100) or `laptop` (built-in keys; any Mac with a battery, overridable in `~/.config/dot/profile`). App scripts that set hotkeys pick their set from it, e.g. `handy/bindings.<profile>.json`.
- `skills/` -- agent skills, linked to `~/.agents/skills`. Per-agent skill dirs (e.g. `~/.claude/skills/*`) already point into it, so new skills need no extra linking.

## Conventions

- VS Code and Cursor share config from `vscode/`; don't create a separate `cursor/` dir.
