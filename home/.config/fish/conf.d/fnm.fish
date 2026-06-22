# Log level ensures no "Using Node v***" message is printed (which can intefer
# with the output of CLI commands, like CtrlSF.vim)
fnm env --log-level=error --use-on-cd | source
