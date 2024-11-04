" Yank to system clipboard
set clipboard=unnamed

" Make , available as a leader key
unmap ,

" Easier command mode
nmap ; :
vmap ; :

" remap U to <C-r> for easier redo
nmap U <C-r>

" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk

" Just to beginning and end of lines easier. From http://vimbits.com/bits/16
nmap H ^
nmap L $
vmap H ^
vmap L $

" Make Y behave like other capital commands.
" Hat-tip http://vimbits.com/bits/11
nmap Y y$

" Fast scroll with arrow keys
nmap <Up> 15gk
nmap <Down> 15gj
vmap <Up> 15gk
vmap <Down> 15gj

" Create newlines without entering insert mode
nnoremap go moo<Esc>`o
nnoremap gO moO<Esc>`o

" Quickly remove search highlights
nmap ,/ :nohl<CR>

" Toggle task completion
exmap toggleTask obcommand editor:toggle-checklist-status
nmap ,x :toggleTask<CR>

" Reload Obsidian
exmap reload obcommand app:reload
nmap ,orr :reload<CR>

" ------
" Panels
" ------

" Toggle left sidebar
exmap toggleLeftSidebar obcommand app:toggle-left-sidebar
nmap ,nn :toggleLeftSidebar<CR>

" Reveal active file in file explorer
exmap revealActiveFile obcommand file-explorer:reveal-active-file
nmap ,nf :revealActiveFile<CR>

" Show bookmarks
exmap showBookmarks obcommand bookmarks:open
nmap ,nb :showBookmarks<CR>

" Toggle right sidebar
exmap toggleRightSidebar obcommand app:toggle-right-sidebar
nmap <F7> :toggleRightSidebar<CR>

" ------
" Search
" ------

" Open file
" switcher:open
exmap openFile obcommand switcher:open
nmap ,ff :openFile<CR>

" Open search
exmap openSearch obcommand global-search:open
nmap ,fr :openSearch<CR>

" ----------
" Navigation
" ----------

exmap nextTab obcommand workspace:next-tab
nmap gt :nextTab<CR>

exmap previousTab obcommand workspace:previous-tab
nmap gT :previousTab<CR>

" Follow link under cursor
exmap followLink :obcommand editor:follow-link
nmap gf :followLink<CR>

" Go back and forward with Ctrl+i and Ctrl+o
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back<CR>

exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>

exmap jumpToLink obcommand mrj-jump-to-link:activate-jump-to-link
nmap <C-f> :jumpToLink<CR>

exmap jumpToAnywhere obcommand mrj-jump-to-link:activate-jump-to-anywhere
nmap s :jumpToAnywhere<CR>

" --------
" Surround
" --------
" Surround.vim-like mappings (but only S key and only current word or
" selection)
exmap surround_wiki surround [[ ]]
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backticks surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }

" Required before mapping S
nunmap S
vunmap S

" NOTE: must use 'map' and not 'nmap'
map [[ :surround_wiki<CR>
map S" :surround_double_quotes<CR>
map S' :surround_single_quotes<CR>
map S` :surround_backticks<CR>
map Sb :surround_brackets<CR>
map S( :surround_brackets<CR>
map S) :surround_brackets<CR>
map S[ :surround_square_brackets<CR>
map S[ :surround_square_brackets<CR>
map S{ :surround_curly_brackets<CR>
map S} :surround_curly_brackets<CR>

" -------
" Windows
" -------

" Window navigation
" NOTE: These are mapped in the Obsidian keymap because they don't work here.
" exmap focusRight obcommand editor:focus-right
" map <A-l> :focusRight<CR>
"
" exmap focusLeft obcommand editor:focus-left
" map <A-h> :focusLeft<CR>
"
" exmap focusTop obcommand editor:focus-top
" map <A-k> :focusTop<CR>
"
" exmap focusBottom obcommand editor:focus-bottom
" map <A-j> :focusBottom<CR>

exmap splitVertical obcommand workspace:split-vertical
nmap ,vs :splitVertical<CR>

exmap splitHorizontal obcommand workspace:split-horizontal
nmap ,hs :splitHorizontal<CR>
