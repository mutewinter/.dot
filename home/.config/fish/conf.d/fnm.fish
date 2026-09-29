# Log level ensures no "Using Node v***" message is printed (which can intefer
# with the output of CLI commands, like CtrlSF.vim)
if type -q fnm
  fnm env --log-level=error --use-on-cd | source
end
