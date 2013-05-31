# Bash aliases shared between zsh and bashrc config.

# Use MacVim for the terminal if it's installed.
if [ -x /usr/local/bin/mvim ]; then
  alias vim="mvim -v"
fi

export EDITOR="vim"

# Commands
alias ezsh="$EDITOR ~/dot_files/_zshrc"
alias vimrc="$EDITOR ~/.vim/vimrc"
alias vundle="$EDITOR ~/.vim/vundle.vim"
alias mappings="$EDITOR ~/.vim/mappings.vim"
alias plugins="$EDITOR ~/.vim/plugin_config.vim"
alias aliases="$EDITOR ~/dot_files/aliases.sh"
alias ag="ag --smart-case"
alias l="ls -1"
alias v="$EDITOR"

# Colors the things that are different, win.
alias gdc="git diff --color-words"
alias glpp="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Directories
alias cvim="cd ~/.vim"
alias cdot="cd ~/dot_files"

# Annotate Rails models
alias rails-annotate="annotate --exclude tests,fixtures,factories -p after"

# Quick way to rebuild the Launch Services database and get rid
# of duplicates in the Open With submenu.
# from: http://www.leancrew.com/all-this/2013/02/getting-rid-of-open-with-duplicates/
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

# Open man pages in Dash.app
man() { open dash://manpages:$1 }
