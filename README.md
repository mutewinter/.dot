# Dot Files

 * `_ackrc` configuration for [Ack](http://betterthangrep.com/).
 * `_bashrc` configuration for [Bash](http://www.gnu.org/software/bash/).
 * `_irbrc` configuration for the [Interactive Ruby
 REPL](http://en.wikipedia.org/wiki/Interactive_Ruby_Shell).
 * `_tmux.conf` configuration for [tmux](http://tmux.sourceforge.net/).
 * `_zshrc` configuration for [ZSH](http://www.zsh.org/), which uses [Oh My
 ZSH](https://github.com/robbyrussell/oh-my-zsh).

## Setup

**Linking Dot Files**

Run `rake link` to link the dot fils in the root of this repo prefixed with a
`_`.

**Linking ZSH Plugins**

Run `rake zsh_plugins` to link the plugin folders from the `zsh` directory to
the `.oh-my-zsh` folder.
