" ---- Misc Options {{{

" Enable modeline and search last line only
set modeline
set modelines=1

" Show command details in last line
set showcmd

" When any type of bracket is typed, briefly jump to the matched one
set showmatch

" Set undo
set undofile

" Fix esc key delays
set timeoutlen=1000 ttimeoutlen=0

" Disable mouse
set mouse=

" Use the global clipboard and the selection clipboard
"set clipboard^=unnamed,unnamedplus
set clipboard+=unnamedplus

" Auto reload kitty when config changes
augroup KittyReload
	autocmd!
	autocmd BufWritePost ~/.config/kitty/*.conf silent! call system('pkill -USR1 -x kitty')
augroup END

" Abbreviations
iabbrev TODO (TODO[DN]:)<Left>

" ---- Misc Options }}}
