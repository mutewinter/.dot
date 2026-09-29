# Bash aliases shared between zsh and bashrc config.

alias codex='codex --dangerously-bypass-approvals-and-sandbox'

# Use Neovim for editing
if [ -x /usr/local/bin/nvim ]; then
  export EDITOR=nvim
  alias vim=nvim
else
  export EDITOR="vim"
fi
