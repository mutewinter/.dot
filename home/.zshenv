# .zshenv
#
# Aliases we want Vim to pickup.
#
# vim: set filetype=sh :

# turbo
# One filesystem cache shared by every checkout and worktree on this machine.
# Absolute is required: a relative path resolves inside each repo, which is the
# per-repo .turbo this replaces. Set here rather than in .zshrc so it reaches
# non-interactive `zsh -c` runs, which is how agents invoke the checks.
export TURBO_CACHE_DIR="$HOME/.cache/turbo"
# turbo end

