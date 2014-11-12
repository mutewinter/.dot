# Code Folder
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

# Checkout Code Folder
ck() { cd ~/code/checkout_code/$1; }
_ck() { _files -W ~/code/checkout_code -/; }
compdef _ck ck

# Bp Folder
bp() { cd ~/code/bp/$1; }
_bp() { _files -W ~/code/bp -/; }
compdef _bp bp

# Dropbox Folder
db() { cd ~/Dropbox/$1; }
_db() { _files -W ~/Dropbox -/; }
compdef _db db

# Pull Request Folder
pr() { cd ~/code/pull_requests/$1; }
_pr() { _files -W ~/code/pull_requests -/; }
compdef _pr pr

# Personal Folder
p() { cd ~/code/personal/$1; }
_p() { _files -W ~/code/personal -/; }
compdef _p p
