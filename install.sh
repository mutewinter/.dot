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

# Stow home package (dotfiles + fish + claude settings)
stow --dir="$DOT" --target="$HOME" home

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

# AGENTS.md chain
symlink "$DOT/_AGENTS.md" "$HOME/.agents/AGENTS.md"
[ -d "$HOME/.claude" ]        && symlink "$HOME/.agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
[ -d "$HOME/.cursor/rules" ]  && symlink "$HOME/.agents/AGENTS.md" "$HOME/.cursor/rules/personal.mdc"
[ -d "$HOME/.codex" ]         && symlink "$HOME/.agents/AGENTS.md" "$HOME/.codex/AGENTS.md"

# File associations (macOS)
if command -v duti &>/dev/null; then
  duti "$DOT/duti.conf"
fi
