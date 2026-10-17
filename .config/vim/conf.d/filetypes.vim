" Filetype Specific Settings --------------------------------------------------

" indentation
augroup indentation
	autocmd!
	autocmd FileType c setlocal shiftwidth=8 tabstop=8 softtabstop=8 expandtab
	autocmd FileType markdown setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
	autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
	autocmd FileType scss setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
augroup END

" line length warning
augroup linelengthwarn
	autocmd!
	autocmd FileType markdown setlocal colorcolumn=
augroup END

" spelling
augroup spelling
	autocmd!
	autocmd FileType c setlocal nospell
	autocmd FileType cpp setlocal nospell
	autocmd FileType vim setlocal nospell
augroup END
