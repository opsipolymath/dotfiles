" ---- Spelling and Completion {{{

" Spelling
set spelllang=en_ca,fr
augroup spelling
	autocmd!
	autocmd FileType markdown setlocal spell
	autocmd FileType gitcommit setlocal spell
	autocmd FileType asciidoctor setlocal spell
augroup END

" Disable automatic commenting on newline
augroup autocomments
	autocmd!
	autocmd FileType * setlocal fo-=c fo-=r fo-=o
augroup END

" Set autocompletion
set wildmode=longest,list,full

" ---- Spelling and Completion }}}
