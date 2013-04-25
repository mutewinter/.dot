# Code Folder
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

# Checkout Code Folder
ck() { cd ~/code/checkout_code/$1; }
_ck() { _files -W ~/code/checkout_code -/; }
compdef _ck ck

# Sparkbox Folder
sb() { cd ~/code/sb/$1; }
_sb() { _files -W ~/code/sb -/; }
compdef _sb sb
