# Bash aliases shared between zsh and bashrc config.

# Use MacVim for the terminal if it's installed.
if [ -x /usr/local/bin/mvim ]; then
  alias vim="mvim -v"
fi

export EDITOR="vim"

# Directories
alias cvim="cd ~/.vim"
alias cdot="cd ~/dot_files"

# Edit Files
alias v="$EDITOR"
alias vimrc="cd ~/.vim; v ~/.vim/vimrc"
alias vundle="v ~/.vim/vundle.vim"
alias mappings="v ~/.vim/mappings.vim"
alias plugins="v ~/.vim/plugin_config.vim"
alias vzsh="v ~/dot_files/_zshrc"
alias aliases="v ~/dot_files/aliases.sh"
alias vdot="cdot; v ."

# Commands
alias ag="ag --smart-case"
alias l="ls -1"

# Colors the things that are different, win.
alias gdc="git diff --color-words"
# From https://coderwall.com/p/euwpig
alias glpp="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glppf="git log -p --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Annotate Rails models
alias annotate-rails="annotate --exclude tests,fixtures,factories -p after"

# Quick way to rebuild the Launch Services database and get rid
# of duplicates in the Open With submenu.
# from: http://www.leancrew.com/all-this/2013/02/getting-rid-of-open-with-duplicates/
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'
