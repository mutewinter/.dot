sb() { cd ~/code/sb/$1; }
_sb() { _files -W ~/code/sb -/; }
compdef _sb sb
