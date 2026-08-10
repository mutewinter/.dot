## Setup

```sh
git clone git@github.com:mutewinter/.dot.git ~/.dot
cd ~/.dot
brew install stow fish fisher
./install.sh
```

`install.sh` uses [stow](https://www.gnu.org/software/stow/) to symlink the `home/` package into `~`, then handles special-case paths:

- **Lazygit** → `~/Library/Application Support/lazygit/config.yml`
- **Codex** → `~/.codex/config.toml`, `~/.codex/config.json`, `~/.codex/keybindings.json`, `~/.codex/rules/default.rules`
- **VS Code** → `~/Library/Application Support/Code/User/`, and `Cursor/User/` when Cursor is installed
- **Karabiner** → `~/.config/karabiner/karabiner.json`
- **AGENTS.md** → `~/.agents/AGENTS.md`, `~/.claude/CLAUDE.md`, `~/.cursor/rules/personal.mdc`
- **Skills** → `~/.agents/skills`
- **File associations** → runs `duti duti.conf` if `duti` is installed

## Fish plugins

Install Fish plugins after running `install.sh`:

```sh
fisher update
```

## Codex

`codex/config.toml` is a curated, shareable subset of the live Codex config. Do not copy auth, sessions, caches, sqlite state, generated images, histories, marketplace timestamps, project trust state, hook trust state, or MCP tokens from `~/.codex`.

## tmux plugins

Run `tmux` then `<C-a> I` to install [tpm](https://github.com/tmux-plugins/tpm) plugins.

## Manual steps

- **linearmouse**: import `linearmouse.json` via the app UI or copy to `~/.config/linearmouse/`
