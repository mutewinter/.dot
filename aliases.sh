# Bash aliases shared between zsh and bashrc config.

alias zshrc="$EDITOR ~/dot_files/_zshrc"
alias vimrc="$EDITOR ~/.vim/vimrc"

# Use MacVim for the terminal if it's installed.
if [ -x /usr/local/bin/mvim ]; then
  alias vim="mvim -v"
fi
