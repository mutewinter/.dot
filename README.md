## Setup

```sh
git clone git@github.com:mutewinter/.dot.git ~/.dot
cd ~/.dot
brew install stow fish fisher
./install.sh
```

`install.sh` uses [stow](https://www.gnu.org/software/stow/) to symlink the `home/` package into `~`, then handles special-case paths:

- **Lazygit** → `~/Library/Application Support/lazygit/config.yml`
- **Cursor** → `~/Library/Application Support/Cursor/User/`
- **Karabiner** → `~/.config/karabiner/karabiner.json`
- **AGENTS.md** → `~/.agents/AGENTS.md`, `~/.claude/CLAUDE.md`, `~/.cursor/rules/personal.mdc`
- **Skills** → `~/.agents/skills`
- **File associations** → runs `duti duti.conf` if `duti` is installed

## Fish plugins

Install Fish plugins after running `install.sh`:

```sh
fisher update
```

## tmux plugins

Run `tmux` then `<C-a> I` to install [tpm](https://github.com/tmux-plugins/tpm) plugins.

## Manual steps

- **linearmouse**: import `linearmouse.json` via the app UI or copy to `~/.config/linearmouse/`
