# Bash aliases shared between zsh and bashrc config.

# Commands
alias zshrc="$EDITOR ~/dot_files/_zshrc"
alias vimrc="$EDITOR ~/.vim/vimrc"

# Colors the things that are different, win.
alias gdc="git diff --color-words"

# Directories
alias cvim="cd ~/.vim"
alias cdot="cd ~/dot_files"

# Use MacVim for the terminal if it's installed.
if [ -x /usr/local/bin/mvim ]; then
  alias vim="mvim -v"
fi
