# ---------------------
# Environment Variables
# ---------------------

# -------------
# Aliases
# -------------
if [ -f ~/.dot/aliases.sh ]; then
  source ~/.dot/aliases.sh
fi

# ---------
# Functions
# ---------
if [ -f ~/.dot/functions.sh ]; then
  source ~/.dot/functions.sh
fi

# -------------------------------------
# System-Specific Environment Variables
# -------------------------------------
if [ -f ~/.dot/system_environment.sh ]; then
  source ~/.dot/system_environment.sh
fi

# ---------------
# Startup Message
# ---------------
hostname

if { hash tmux 2>/dev/null; } && ! { [ -n "$TMUX" ]; } then
  if { tmux list-sessions > /dev/null 2>&1; } then
    echo '\ntmux sessions'
    echo '-------------'
    tmux list-sessions -F " #{?session_attached,⚙, } #S"
  else
    echo '\nno tmux sessions'
    echo '----------------'
  fi
fi

PATH=$PATH:/usr/local/share/npm/bin
# Source coreutils in the path first so dircolors is available.
# We're using https://github.com/trapd00r/LS_COLORS for sweet file-type colors.
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# For Homebrew
PATH=$PATH:/usr/local/sbin
PATH="/usr/local/bin:$PATH"

# My own programs
PATH=$PATH:~/programs

# What a world
export SCARF_ANALYTICS=false

# Disable automatic upgrade of Homebrew packages
HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
