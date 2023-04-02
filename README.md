## Setup

1. `git clone --recursive git@github.com:mutewinter/.dot.git`
1. Install oh-my-zsh
1. `brew install coreutils`
1. `brew cask install font-sourcecodepro-nerd-font`
1. `rm ~/.zshrc`
1. `rake link`
1. `rm -rf ~/.oh-my-zsh/custom/plugins && rm -rf ~/.oh-my-zsh/custom/themes`
1. `rake zsh:all`
1. `rake karabiner`
1. `rake lazygit`
1. may be covered by recursive clone `git clone https://github.com/tmux-plugins/tpm ~/.dot/tmux/plugins/tpm`
1. Run `tmux` then type `<C-a> I` to install tpm plugins
