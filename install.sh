#!/usr/bin/env bash
set -e

DOT="$(cd "$(dirname "$0")" && pwd)"
NL=$'\n'

# Managed paths this run could not claim, reported together once everything else
# has been linked. Collecting them beats failing on the first one: the rest of
# the install still has value, and a single list at the end survives the scroll.
unclaimed=()

# An app that writes its own config before the first install owns that path
# forever, because ln refuses to clobber it. Nothing here replaces a file this
# repo did not write, since that config is the only copy of whatever state the
# app keeps in it. The path is named instead, loudly enough to act on.
symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ ! -e "$src" ]; then
    unclaimed+=("$src is missing from this repo${NL}    wanted by: $dst")
    echo "NO SOURCE: $src"
  elif [ "$dst" -ef "$src" ]; then
    echo "ok: $dst"
  elif [ -L "$dst" ]; then
    unclaimed+=("$dst -> $(readlink "$dst")${NL}    want: $src")
    echo "WRONG TARGET: $dst -> $(readlink "$dst")"
  elif [ -e "$dst" ]; then
    unclaimed+=("$dst is a real $([ -d "$dst" ] && echo directory || echo file)${NL}    want: $src")
    echo "NOT A SYMLINK: $dst"
  else
    ln -s "$src" "$dst"
    echo "linked: $dst"
  fi
}

report_unclaimed() {
  if [ ${#unclaimed[@]} -eq 0 ]; then
    return 0
  fi
  echo
  echo "${#unclaimed[@]} path(s) are not linked to this repo, so edits here do not reach them:"
  local entry
  for entry in "${unclaimed[@]}"; do
    echo "  $entry"
  done
  echo
  echo "Back up each one, delete it, and re-run this script to claim the path."
}

unstow_identical_files() {
  local package="$1" target="$2" src rel dst
  while IFS= read -r -d '' src; do
    rel="${src#$package/}"
    dst="$target/$rel"
    if [ -f "$dst" ] && [ ! -L "$dst" ] && [ ! "$dst" -ef "$src" ] && cmp -s "$src" "$dst"; then
      rm "$dst"
    fi
  done < <(find "$package" -type f -print0)
}

# Stow home package (dotfiles + fish + claude settings)
unstow_identical_files "$DOT/home" "$HOME"
# stow links a whole directory when the target is missing, which on a fresh
# machine would send everything Claude Code and other apps write into this repo.
mkdir -p "$HOME/.claude" "$HOME/.config"
stow --dir="$DOT" --target="$HOME" home

# fish-eza plugin: its alias option vars live in fish_variables, which is
# gitignored (machine-local universal var store), so a fresh machine needs
# the plugin's install event re-fired or every ll/la/etc. alias silently
# falls back to bare eza with no flags.
if command -v fish &>/dev/null && ! fish -c 'set -q EZA_STANDARD_OPTIONS' &>/dev/null; then
  fish -c 'emit fish-eza_install' &>/dev/null
  echo "fish-eza: initialized alias options"
fi

# Lazygit
symlink "$DOT/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"

# Hunk
symlink "$DOT/hunk/config.toml" "$HOME/.config/hunk/config.toml"

# Codex
symlink "$DOT/codex/keybindings.json" "$HOME/.codex/keybindings.json"
symlink "$DOT/codex/rules" "$HOME/.codex/rules"
# Codex rewrites config.toml with machine state, so it is seeded, not linked.
if [ ! -e "$HOME/.codex/config.toml" ]; then
  cp "$DOT/codex/config.seed.toml" "$HOME/.codex/config.toml"
  echo "seeded: $HOME/.codex/config.toml"
fi

# VS Code
for f in keybindings.json settings.json snippets; do
  symlink "$DOT/vscode/$f" "$HOME/Library/Application Support/Code/User/$f"
done

# Cursor (shares VS Code config)
if [ -d "$HOME/Library/Application Support/Cursor/User" ]; then
  for f in keybindings.json settings.json snippets; do
    symlink "$DOT/vscode/$f" "$HOME/Library/Application Support/Cursor/User/$f"
  done
fi

# Karabiner saves by replacing karabiner.json, which turns a file symlink back
# into a real file, so the whole directory is linked as its docs recommend.
symlink "$DOT/karabiner" "$HOME/.config/karabiner"

# LinearMouse, linked by directory for the same reason as Karabiner
symlink "$DOT/linearmouse" "$HOME/.config/linearmouse"

# Ghostty
symlink "$DOT/ghostty/config" "$HOME/.config/ghostty/config"

# Herdr
symlink "$DOT/herdr/config.toml" "$HOME/.config/herdr/config.toml"
# Herdr resolves relative sound paths from the real ~/.config/herdr, not through
# the config symlink, so the sounds directory needs its own link.
symlink "$DOT/herdr/sounds" "$HOME/.config/herdr/sounds"

# The SessionStart hooks that report agent sessions to Herdr run scripts Herdr
# generates and owns, so they aren't in this repo. Reinstalling writes them back
# and leaves the already-registered hooks alone.
if command -v herdr &>/dev/null; then
  [ -d "$HOME/.claude" ] && herdr integration install claude
  [ -d "$HOME/.codex" ]  && herdr integration install codex
fi

# Raycast script commands
symlink "$DOT/raycast/focus-electron.applescript" "$HOME/Documents/Raycast/focus-electron.applescript"

# AGENTS.md chain
symlink "$DOT/_AGENTS.md" "$HOME/.agents/AGENTS.md"
[ -d "$HOME/.claude" ]        && symlink "$HOME/.agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
[ -d "$HOME/.cursor/rules" ]  && symlink "$HOME/.agents/AGENTS.md" "$HOME/.cursor/rules/personal.mdc"
[ -d "$HOME/.codex" ]         && symlink "$HOME/.agents/AGENTS.md" "$HOME/.codex/AGENTS.md"

# Skills
symlink "$DOT/skills" "$HOME/.agents/skills"

# Skills sourced from another checkout on this machine. Linking them into
# skills/ puts them under ~/.agents/skills and the Claude mirror below like any
# other skill; the links are gitignored since their targets are local paths.
[ -d "$HOME/code/instrument/skills/skills/create-page" ] && symlink "$HOME/code/instrument/skills/skills/create-page" "$DOT/skills/create-page"

# Claude reads skills from ~/.claude/skills, not ~/.agents/skills, so mirror
# each one in individually rather than symlinking the directory itself --
# ~/.claude/skills also holds plugin-installed skills that don't live here.
if [ -d "$HOME/.claude/skills" ]; then
  for skill_dir in "$DOT"/skills/*/; do
    skill="$(basename "$skill_dir")"
    symlink "$HOME/.agents/skills/$skill" "$HOME/.claude/skills/$skill"
  done
fi

# Visual answers and wireframes live in iCloud Drive; agents write to ~/<name>.
pages="$HOME/Library/Mobile Documents/com~apple~CloudDocs/HTML Pages"
if [ -d "$pages" ]; then
  symlink "$pages/Visual Answers" "$HOME/visual-answers"
  symlink "$pages/Wireframes" "$HOME/wireframes"
fi

# File associations (macOS)
if command -v duti &>/dev/null; then
  duti "$DOT/duti.conf"
fi

# Fast key repeat with no accent popup on hold. Takes effect after logging out.
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 25
defaults write -g ApplePressAndHoldEnabled -bool false

# Stay awake on power so agents keep running behind a locked screen: the
# display sleeps and the screen saver locks it, but the system never sleeps.
defaults -currentHost write com.apple.screensaver idleTime -int 1200
if [ "$(pmset -g custom | awk '$1 == "sleep" { print $2; exit }')" != 0 ]; then
  echo "power: run 'sudo pmset -c sleep 0 displaysleep 30 disksleep 0' so the system never sleeps on power"
fi
if ! sysadminctl -screenLock status 2>&1 | grep -q immediate; then
  echo "lock: run 'sysadminctl -screenLock immediate -password -' to require the password right after the screen saver"
fi

# Keyboard layout for the Model 100. Copied rather than linked because macOS
# does not reliably load layouts through a symlink. Enable it afterwards in
# System Settings > Keyboard > Input Sources.
layout="US without Meta Unicode.bundle"
if [ ! -d "$HOME/Library/Keyboard Layouts/$layout" ]; then
  mkdir -p "$HOME/Library/Keyboard Layouts"
  cp -R "$DOT/$layout" "$HOME/Library/Keyboard Layouts/"
  echo "copied: $layout (log out, then add it in Input Sources)"
fi

report_unclaimed
