# ---------------------
# Environment Variables
# ---------------------

PATH=$PATH:/usr/local/share/npm/bin
# Source coreutils in the path first so dircolors is available.
# We're using https://github.com/trapd00r/LS_COLORS for sweet file-type colors.
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
