set -U fish_autosuggestion_enabled 1

# ~/.local/bin
if not string match -q -- "$HOME/.local/bin" $PATH
  set -gx PATH "$HOME/.local/bin" $PATH
end
# ~/.local/bin end

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

