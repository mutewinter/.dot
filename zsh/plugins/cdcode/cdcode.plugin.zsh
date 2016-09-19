# Code Folder
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

# Reference Folder
re() { cd ~/code/reference/$1; }
_re() { _files -W ~/code/reference -/; }
compdef _re re

# Bp Folder
b() { cd ~/code/bp/$1; }
_b() { _files -W ~/code/bp -/; }
compdef _b b

# Dropbox Folder
db() { cd ~/Dropbox/$1; }
_db() { _files -W ~/Dropbox -/; }
compdef _db db

# Pull Request Folder
pr() { cd ~/code/pull_requests/$1; }
_pr() { _files -W ~/code/pull_requests -/; }
compdef _pr pr

# Postlight Folder
p() { cd ~/code/postlight/$1; }
_p() { _files -W ~/code/postlight -/; }
compdef _p p

# Persoal Folder
personal() { cd ~/code/personal/$1; }
_personal() { _files -W ~/code/personal -/; }
compdef _personal personal

# Forks Folder
forks() { cd ~/code/forks/$1; }
_forks() { _files -W ~/code/forks -/; }
compdef _forks forks
