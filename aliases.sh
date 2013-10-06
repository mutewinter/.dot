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
alias pomo="pomojs -t"

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

alias stripwhitespace='find . -not \( -name .svn -prune -o -name .git -prune -name tmp -prune \) -type f -print0 | xargs -0 sed -i '' -E "s/[[:space:]]*$//"'

# From http://alias.sh/extract-most-know-archives-one-command
function extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# From http://alias.sh/make-and-cd-directory
function mcd() {
  mkdir -p "$1" && cd "$1";
}
