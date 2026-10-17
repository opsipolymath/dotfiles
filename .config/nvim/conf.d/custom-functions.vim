" Compare staged configuration files with their installed versions.
function! OpenDiff() abort
	let l:root = expand('~/config/')
	let l:current = expand('%:p')
	if stridx(l:current, l:root) != 0
		echoerr 'Open a file under ~/config first'
		return
	endif
	let l:installed = expand('~/.config/') . strpart(l:current, strlen(l:root))
	if !filereadable(l:installed)
		echoerr 'No installed counterpart: ' . l:installed
		return
	endif
	execute 'vert diffsplit' fnameescape(l:installed)
endfunction
nnoremap <leader>cd :call OpenDiff()<CR>

function! NextDiff() abort
	wincmd h
	only
	next
	call OpenDiff()
endfunction
nnoremap <leader>cn :call NextDiff()<CR>
