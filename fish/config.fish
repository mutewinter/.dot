set -U fish_autosuggestion_enabled 1

# pnpm
set -gx PNPM_HOME "/Users/mytop/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
