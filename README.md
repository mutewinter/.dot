# Dot Files

 * `_ackrc` configuration for [Ack](http://betterthangrep.com/).
 * `_bashrc` configuration for [Bash](http://www.gnu.org/software/bash/).
 * `_irbrc` configuration for the [Interactive Ruby
 REPL](http://en.wikipedia.org/wiki/Interactive_Ruby_Shell).
 * `_tmux.conf` configuration for [tmux](http://tmux.sourceforge.net/).
 * `_zshrc` configuration for [ZSH](http://www.zsh.org/), which uses [Oh My
 ZSH](https://github.com/robbyrussell/oh-my-zsh).

## Setup

`git clone --recursive https://github.com/mutewinter/dot_files`

_note: the --recursive ensures submodules are installed_

**Linking Dot Files**

Run `rake link` to link the dot fils in the root of this repo prefixed with a
`_`.

**Linking ZSH Plugins**

Run `rake zsh:all` to link all of the custom zsh files to the
`.oh-my-zsh/custom` folder.
