" ---- Vimwiki {{{

" -- Create Wiki Entries {{{
function! CreateNote() range
	let [l:start_line, l:start_column] = getpos("'<")[1:2]
	let [l:end_line, l:end_column] = getpos("'>")[1:2]
	let l:lines = getline(l:start_line, l:end_line)
	let l:lines[-1] = l:lines[-1][: l:end_column - (&selection == 'inclusive' ? 1 : 2)]
	let l:lines[0] = l:lines[0][l:start_column - 1:]
	let l:selected_text = join(l:lines, "\n")
	silent! execute "!mkwikinote note " . shellescape(l:selected_text)
endfunction
noremap <leader>wn :call CreateNote()<return>:echon ''<return>
function! CreateBook() range
	let [l:start_line, l:start_column] = getpos("'<")[1:2]
	let [l:end_line, l:end_column] = getpos("'>")[1:2]
	let l:lines = getline(l:start_line, l:end_line)
	let l:lines[-1] = l:lines[-1][: l:end_column - (&selection == 'inclusive' ? 1 : 2)]
	let l:lines[0] = l:lines[0][l:start_column - 1:]
	let l:selected_text = join(l:lines, "\n")
	silent! execute "!mkwikinote book " . shellescape(l:selected_text)
endfunction
noremap <leader>wb :call CreateBook()<return>:echon ''<return>
" -- Create Wiki Entries }}}

" -- Update Diary Index {{{
command! Diary VimwikiDiaryIndex
augroup vimwikigroup
	autocmd!
	" automatically update links on read diary
	autocmd BufRead,BufNewFile */lyceum/content/inbox/quick-notes/overview.md VimwikiDiaryGenerateLinks
augroup END
" -- Update Diary Index }}}

" ---- Vimwiki }}}
