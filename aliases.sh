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

# Directories
alias cvim="cd ~/.config/nvim"
alias cdot="cd ~/.dot"

# Edit Files
alias v="$EDITOR"
alias vf="$EDITOR \$(fzf)"
alias vimrc="cd ~/.vim; v ~/.vim/vimrc"
alias vundle="v ~/.vim/vundle.vim"
alias mappings="v ~/.vim/mappings.vim"
alias plugins="v ~/.vim/plugins.vim"
alias vzsh="v ~/.dot/_zshrc"
alias aliases="v ~/.dot/aliases.sh"

# Commands
alias ls="ls --color"
alias l="ls -1"

# Colors the things that are different, win.
alias gdc="git diff --color-words"
# From https://coderwall.com/p/euwpig
alias glpp="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glppf="git log -p --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Lazygit
alias lg="lazygit"

# Quick way to rebuild the Launch Services database and get rid
# of duplicates in the Open With submenu.
# from: http://www.leancrew.com/all-this/2013/02/getting-rid-of-open-with-duplicates/
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

# NPM
alias n=npm

# Tmux
alias tm="tmux attach || tmux new"

# Yarn
alias y=yarn

# CW
alias cwselect="cw tail -f -n -t \$(cw ls groups | fzf -m | tr '\n' ' ')"
