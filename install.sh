#!/usr/bin/env bash
set -e

DOT="$(cd "$(dirname "$0")" && pwd)"

symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "exists, skipping: $dst"
  else
    ln -s "$src" "$dst"
    echo "linked: $dst"
  fi
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

# Cursor
for f in keybindings.json settings.json snippets; do
  symlink "$DOT/cursor/$f" "$HOME/Library/Application Support/Cursor/User/$f"
done

# VS Code (shares cursor config)
for f in keybindings.json settings.json snippets; do
  symlink "$DOT/cursor/$f" "$HOME/Library/Application Support/Code/User/$f"
done

# Karabiner
symlink "$DOT/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

# Ghostty
symlink "$DOT/ghostty/config" "$HOME/.config/ghostty/config"

# Raycast script commands
symlink "$DOT/raycast/focus-electron.applescript" "$HOME/Documents/Raycast/focus-electron.applescript"

# AGENTS.md chain
symlink "$DOT/_AGENTS.md" "$HOME/.agents/AGENTS.md"
[ -d "$HOME/.claude" ]        && symlink "$HOME/.agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
[ -d "$HOME/.cursor/rules" ]  && symlink "$HOME/.agents/AGENTS.md" "$HOME/.cursor/rules/personal.mdc"
[ -d "$HOME/.codex" ]         && symlink "$HOME/.agents/AGENTS.md" "$HOME/.codex/AGENTS.md"

# Skills
symlink "$DOT/skills" "$HOME/.agents/skills"

# File associations (macOS)
if command -v duti &>/dev/null; then
  duti "$DOT/duti.conf"
fi
