" fix home/end
if $TERM =~ '^screen-256color'
	map <Esc>OH <Home>
	map! <Esc>OH <Home>
	map <Esc>OF <End>
	map! <Esc>OF <End>
endif

" navigate displayed lines instead of physical lines
nnoremap k gk
nnoremap j gj
nnoremap <Home> g<Home>
nnoremap <End> g<End>
inoremap <C-o>k <C-o>gk
inoremap <C-o>j <C-o>gj
inoremap <Home> <C-o>g<Home>
inoremap <End> <C-o>g<End>

" make switching splits easier
nnoremap <C-l> <C-W><C-L>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-j> <C-W><C-J>
nnoremap <C-h> <C-W><C-H>
inoremap <C-l> <C-W><C-L>
inoremap <C-k> <C-W><C-K>
inoremap <C-j> <C-W><C-J>
inoremap <C-h> <C-W><C-H>
tmap <C-h> <C-\><C-N><C-h>
tmap <C-l> <C-\><C-N><C-l>
tmap <C-j> <C-\><C-N><C-j>
tmap <C-k> <C-\><C-N><C-k>

" terminal keybinds
tnoremap <Esc> <C-\><C-n>
tnoremap <silent><C-D> <C-D><C-\><C-N>ZQ

" Abbreviations ---------------------------------------------------------------
iabbrev TODO (TODO[DN]:)<Left>
