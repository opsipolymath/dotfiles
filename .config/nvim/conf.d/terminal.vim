" ---- Terminal {{{

augroup TerminalStuff
	autocmd!
	" Remove line numbers
	autocmd TermOpen * setlocal nonumber norelativenumber
	" Start in insert mode
	autocmd TermOpen term://* startinsert
	autocmd BufWinEnter,WinEnter term://* startinsert
augroup END

" ---- Terminal }}}
