" Yank to system clipboard
set clipboard=unnamed

" remap U to <C-r> for easier redo
nmap U <C-r>

" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk
vmap j gj
vmap k gk

" H and L for beginning/end of line
nmap H ^
nmap L $
vmap H ^
vmap L $

" Fast scroll with arrow keys
nmap <Up> 15gk
nmap <Down> 15gj
vmap <Up> 15gk
vmap <Down> 15gj

" Easier command mode
nmap ; :
vmap ; :

" Doesn't work currently, not sure how to do leader
" Quickly remove search highlights
" nmap ,/ :nohl

" Just to beginning and end of lines easier. From http://vimbits.com/bits/16
nmap H ^
nmap L $
vmap H ^
vmap L $

" Make Y behave like other capital commands.
" Hat-tip http://vimbits.com/bits/11
nmap Y y$

" Follow link under cursor
exmap followLink :obcommand editor:follow-link
nmap gf :followLink

" Go back and forward with Ctrl+i and Ctrl+o
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back

exmap forward obcommand app:go-forward
nmap <C-i> :forward

exmap jumpToLink obcommand mrj-jump-to-link:activate-jump-to-link
nmap <C-f> :jumpToLink

exmap jumpToAnywhere obcommand mrj-jump-to-link:activate-jump-to-anywhere
nmap s :jumpToAnywhere

" Create newlines without entering insert mode
nnoremap go moo<Esc>`o
nnoremap gO moO<Esc>`o

" Window navigation
" Try again once https://github.com/esm7/obsidian-vimrc-support/issues/78
" lands
" exmap focusRight obcommand editor:focus-right
" nmap <A-l> :focusRight
"
" exmap focusLeft obcommand editor:focus-left
" nmap <A-h> :focusLeft
"
" exmap focusTop obcommand editor:focus-top
" nmap <A-k> :focusTop
"
" exmap focusBottom obcommand editor:focus-bottom
" nmap <A-j> :focusBottom
