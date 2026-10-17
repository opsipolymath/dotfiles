" ---- User Interface {{{

" -- Colours, Cursor, and Line Numbers {{{
" Color Scheme
colorscheme nord
set background=dark
hi Visual cterm=inverse ctermfg=green

" Cursor
set guicursor=i:hor20-Cursor

" Keep cursorline vertically centered
set scrolloff=999

" Line Numbering
set number relativenumber
set cursorline
hi CursorLine cterm=inverse ctermfg=blue
hi CursorLineNr cterm=inverse ctermfg=blue
hi LineNr ctermfg=blue
" -- Colours, Cursor, and Line Numbers }}}

" -- Folding {{{
" Fold Options
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax
set fillchars=fold:\ " remove trailing characters
let g:sh_fold_enabled = 5
let g:is_bash = 1
nnoremap <space> za

" Fold Text
function! MyFoldText()
	" Clean up folded text
	let l:line = getline(v:foldstart)
	" Set width of fold text
	let l:number_column_width = &fdc + &number * &numberwidth
	" Full screen width fold text
	let l:fold_text_width = winwidth(0) - l:number_column_width - 3
	" Count of number of lines in fold
	let l:folded_line_count = v:foldend - v:foldstart
	" Expand tabs into spaces
	let l:tab_spaces = strpart('          ', 0, &tabstop)
	let l:line = substitute(l:line, '\t', l:tab_spaces, 'g')
	" Remove open curly braces or `() {`
	let l:line = strpart(l:line, 0, strlen(l:line) - 4)
	let l:line = strpart(l:line, 0, l:fold_text_width - 7 - len(l:folded_line_count))
	" Calculate number of filler characters needed
	let l:fill_char_count = l:fold_text_width - len(l:line) - len(l:folded_line_count) - 5
	" Return the fold text
	return l:line . ' ' . repeat("-", l:fill_char_count) . ' '
		\ . l:folded_line_count . " lines"
endfunction
set foldtext=MyFoldText()
" -- Folding }}}

" -- Special Characters and Concealing {{{
" Show Tabs and Spaces
set list listchars=nbsp:¬,tab:»·,trail:·,extends:>

" Highlight trailing whitespace
hi ExtraWhitespace ctermbg=red guifg=red
match ExtraWhitespace /\s\+$\| \+\ze\t \| [^\t]\zs\t\+/
autocmd colorscheme * hi ExtraWhitespace ctermbg=red guifg=red

" Conceal text completely unless a replacement is defined
set conceallevel=2
" -- Special Characters and Concealing }}}

" -- Splits and Status Line {{{
" Split Below or Right instead of Above or Left
set splitbelow splitright

" Status Line
set laststatus=2
" -- Splits, Status Line }}}

" -- Syntax Highlighting, Wrapping, and Indentation {{{
" Syntax Highlighting
syntax enable
syntax on

" Wrap at word boundaries
set wrap
set linebreak

" Indent wrapped text with indicator
set cpo+=n
set showbreak=+++\ 
hi NoneText ctermfg=green

" Filetype Indentation
filetype plugin indent on

" General Indentation
set shiftwidth=8
set tabstop=8
set softtabstop=8
set noexpandtab

" Filetype-Specific Indentation
augroup indentation
	autocmd!
	autocmd FileType markdown setlocal shiftwidth=4 tabstop=4 softtabstop=4
	autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
	autocmd FileType scss setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
	autocmd FileType vimwiki setlocal shiftwidth=4 tabstop=4 softtabstop=4
augroup END
" -- Syntax Highlighting and Indentation }}}

" ---- User Interface }}}
