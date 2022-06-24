# Editor
abbr v $EDITOR
abbr vim $EDITOR

# Git
abbr g git
abbr ga git add
abbr gco git checkout
abbr gc git commit
abbr gca git commit -v -a
abbr gcm git commit -m
abbr gss git status -sb
abbr gd git diff
alias glpp "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Tmux
alias tm="tmux attach || tmux new"

# Directories
alias cvim="cd ~/.config/nvim"
alias cdot="cd ~/.dot"

abbr personal cd ~/code/personal
abbr reference cd ~/code/reference

# Layzgit
abbr lg lazygit

# NPM
abbr n npm

# Yarn
abbr y yarn

# CW
alias cwselect="cw tail -f -n -t \$(cw ls groups | fzf -m | tr '\n' ' ')"
