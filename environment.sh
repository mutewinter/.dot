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

# What a world
export SCARF_ANALYTICS=false

# Disable automatic upgrade of Homebrew packages
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

# Use opt location for Homebrew first (from ARM Mac)
if [ -d /opt/homebrew/bin ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi
