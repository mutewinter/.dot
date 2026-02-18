# Bash aliases shared between zsh and bashrc config.

# Use Neovim for editing
if [ -x /usr/local/bin/nvim ]; then
  export EDITOR=nvim
  alias view="nvim -v"
  alias vim=nvim
  alias vimdiff="nvim -vd"
  alias gvim=nvim
else
  export EDITOR="vim"
fi