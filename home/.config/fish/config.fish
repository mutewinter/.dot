set -U fish_autosuggestion_enabled 1

# ~/.local/bin
if not string match -q -- "$HOME/.local/bin" $PATH
  set -gx PATH "$HOME/.local/bin" $PATH
end
# ~/.local/bin end

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
# pnpm 12 links bins and its runtime shims into $PNPM_HOME/bin; older installs
# put them directly in $PNPM_HOME.
for dir in "$PNPM_HOME" "$PNPM_HOME/bin"
  if not string match -q -- $dir $PATH
    set -gx PATH $dir $PATH
  end
end
# pnpm end

# turbo
# One filesystem cache shared by every checkout and worktree on this machine.
# Absolute is required: a relative path resolves inside each repo, which is the
# per-repo .turbo this replaces.
set -gx TURBO_CACHE_DIR "$HOME/.cache/turbo"
# turbo end

