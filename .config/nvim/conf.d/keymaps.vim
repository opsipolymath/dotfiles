" ---- Keymaps {{{

" Fix home/end
if $TERM =~ '^screen-256color'
	map <Esc>OH <Home>
	map! <Esc>OH <Home>
	map <Esc>OF <End>
	map! <Esc>OF <End>
endif

" Color column presets
map <silent> <F2> :set cc=0<CR>
map <silent> <F3> :set cc=80,100 \| match ErrorMsg '\%>119v.\+'<CR>
map <silent> <F4> :set cc=40,45,80<CR>

" Navigate displayed lines instead of physical lines
nnoremap k gk
nnoremap j gj
nnoremap <Home> g<Home>
nnoremap <End> g<End>
inoremap <C-o>k <C-o>gk
inoremap <C-o>j <C-o>gj
inoremap <Home> <C-o>g<Home>
inoremap <End> <C-o>g<End>

" Make switching splits easier
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

" Terminal keybinds
tnoremap <Esc> <C-\><C-n>
tnoremap <silent><C-D> <C-D><C-\><C-N>ZQ

" Let :we do :w then :e
nnoremap :we :w<CR>:e<CR>

" ---- Keymaps }}}
