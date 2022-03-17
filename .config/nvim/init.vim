" $XDG_CONFIG_HOME/nvim/init.vim
"
" Neovim config file

" ---- Plugins {{{

" -- Install Plugins {{{
" Download plugged if it doesn't exist already
if empty(glob('$XDG_DATA_HOME/nvim/site/autoload/plug.vim'))
	silent !curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugin list
call plug#begin('$XDG_DATA_HOME/nvim/site/plugged')
	Plug 'Fymyte/rasi.vim'
	Plug 'ap/vim-css-color'
	Plug 'arcticicestudio/nord-vim'
	Plug 'dhruvasagar/vim-zoom'
	Plug 'itchyny/lightline.vim'
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'junegunn/goyo.vim'
	Plug 'junegunn/vim-easy-align'
	Plug 'lervag/vimtex'
	Plug 'mzlogin/vim-markdown-toc'
	Plug 'preservim/nerdtree'
	Plug 'thisisrandy/vim-outdated-plugins'
	Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
	Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
call plug#end()
" -- Install Plugins }}}

" -- Plugin Settings {{{
" nord-vim
let g:nord_uniform_status_lines = 1

" lightline
let g:lightline = {
	\ 'colorscheme': 'nord',
	\ 'active': {
	\     'right': [ [ 'lineinfo'], ['percent'], ['filetype'] ] },
	\ 'component': {
	\     'filename': '%F'}
	\ }

" vimtex
let g:vimtex_view_method='general'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='abdmg'

" vimwiki
let g:vimwiki_list = [ {
	\ 'path'             : '~/notebook/content',
	\ 'index'            : '_index',
	\ 'syntax'           : 'markdown',
	\ 'ext'              : '.md',
	\ 'links_space_char' : '-'
	\ }, {
	\ 'path'             : '~/lyceum/content',
	\ 'index'            : '_index',
	\ 'syntax'           : 'markdown',
	\ 'ext'              : '.md',
	\ 'links_space_char' : '-',
	\ 'diary_rel_path'   : '/inbox/quick-notes',
	\ 'diary_index'      : 'overview',
	\ 'diary_header'     : 'Quick Notes'
	\ } ]
let g:vimwiki_ext2syntax = {
	\ '.md'       : 'markdown',
	\ '.markdown' : 'markdown',
	\ '.mdown'    : 'markdown'
	\ }
let g:vimwiki_markdown_link_ext = 0

" vim-latex-live-preview
let g:livepreview_previewer = 'zathura'
let g:livepreview_cursorhold_recompile = 0
" -- Plugin Settings }}}

" ---- Plugins }}}

" ---- User Interface {{{

" -- Colours, Cursor, and Line Numbers {{{
" Color Scheme
colorscheme nord
set background=light
hi Visual cterm=inverse

" Cursor
set guicursor=i:hor20-Cursor

" Line Numbering
set number relativenumber
set cursorline
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
let g:sh_fold_enabled=5
let g:is_bash=1
nnoremap <space> za

" Fold Text
function! MyFoldText()
	" Clean up folded text
	let line = getline(v:foldstart)
	" Set width of fold text
	let nucolwidth = &fdc + &number * &numberwidth
	" Full screen width fold text
	let foldtxtwidth = winwidth(0) - nucolwidth - 3
	" Count of number of lines in fold
	let foldedlinecount = v:foldend - v:foldstart
	" Expand tabs into spaces
	let onetab = strpart('          ', 0, &tabstop)
	let line = substitute(line, '\t', onetab, 'g')
	" Remove open curly braces or `() {`
	let line = strpart(line, 0, strlen(line) - 4)
	let line = strpart(line, 0, foldtxtwidth - 7 -len(foldedlinecount))
	" Calculate number of filler characters needed
	let fillcharcount = foldtxtwidth - len(line) - len(foldedlinecount) - 5
	" Return the fold text
	return line . ' ' . repeat("-",fillcharcount) . ' '
		\ . foldedlinecount . " lines"
endfunction
set foldtext=MyFoldText()
" -- Folding }}}

" -- Special Characters and Concealing {{{
" Show Tabs and Spaces
set list listchars=nbsp:¬,tab:»·,trail:·,extends:>

" Highlight training whitespace
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

" Enable wordw rapping but break at breakpoints
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
autocmd FileType md      setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType html    setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType scss    setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType vimwiki setlocal shiftwidth=4 tabstop=4 softtabstop=4
" -- Syntax Highlighting and Indentation }}}

" ---- User Interface }}}

" ---- Spelling and Completion {{{

" Spelling
set spelllang=en_ca,fr
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" Disable automatic commenting on newline
autocmd FileType * set fo-=c fo-=r fo-=o

" Set autocompletion
set wildmode=longest,list,full

" ---- Spelling and Completion }}}

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

" ---- Misc Options }}}

" ---- Terminal {{{

augroup TerminalStuff
	" Disable all previous autocmds
	autocmd!
	" Remove line numbers
	autocmd TermOpen * setlocal nonumber norelativenumber
	" Start in insert mode
	autocmd TermOpen term://* startinsert
augroup END

" ---- Terminal }}}

" ---- Keymaps {{{

" Fix home/end
if $TERM =~ '^screen-256color'
    map <Esc>OH <Home>
    map! <Esc>OH <Home>
    map <Esc>OF <End>
    map! <Esc>OF <End>
endif

" Various CursorColor highlighting options
map <F2> :set cc=0<CR>
map <F3> :set cc=80,100 \| match ErrorMsg '\%>119v.\+'<CR>
map <F4> :set cc=40,45,80<CR>

" Navigate displayed lines instead of physical lines
noremap  <buffer> <silent> k      gk
noremap  <buffer> <silent> j      gj
noremap  <buffer> <silent> 0      g0
noremap  <buffer> <silent> $      g$
noremap  <buffer> <silent> <Home> g<Home>
noremap  <buffer> <silent> <End>  g<End>
inoremap <buffer> <silent> <C-o>k <C-o>gk
inoremap <buffer> <silent> <C-o>j <C-o>gj
inoremap <buffer> <silent> <C-o>0 <C-o>g0
inoremap <buffer> <silent> <C-o>$ <C-o>g$
inoremap <buffer> <silent> <Home> <C-o>g<Home>
inoremap <buffer> <silent> <End>  <C-o>g<End>

" ---- Keymaps }}}

" ---- Vimwiki {{{

" -- Create Wiki Entries {{{
function! CreateNote() range
	let [lnum1, col1] = getpos("'<")[1:2]
	let [lnum2, col2] = getpos("'>")[1:2]
	let lines = getline(lnum1, lnum2)
	let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][col1 - 1:]
	let selectedText = join(lines, "\n")
	silent! execute "!mkwikinote note " . selectedText
endfunction
noremap <leader>wn :call CreateNote()<return>:echon ''<return>
function! CreateBook() range
	let [lnum1, col1] = getpos("'<")[1:2]
	let [lnum2, col2] = getpos("'>")[1:2]
	let lines = getline(lnum1, lnum2)
	let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][col1 - 1:]
	let selectedText = join(lines, "\n")
	silent! execute "!mkwikinote book " . "\'" . selectedText . "\'"
endfunction
noremap <leader>wb :call CreateBook()<return>:echon ''<return>
" -- Create Wiki Entries }}}

" -- Automatically Index Update {{{
command! Diary VimwikiDiaryIndex
augroup vimwikigroup
    autocmd!
    " automatically update links on read diary
    autocmd BufRead,BufNewFile */lyceum/content/inbox/quick-notes/overview.md VimwikiDiaryGenerateLinks
augroup end
" -- Automatically Index Update }}}

" ---- Vimwiki }}}

" ---- Custom Functions {{{

" -- Dotfiles {{{
" Open real version of current file
function OpenDiff()
	let dotfile = expand('%:p')
	let realfile = "~" . dotfile[23:]
	execute 'vs' realfile
	" call ToggleDiff()
	windo diffthis
endfunction
map <leader>cd :call OpenDiff()<return>

" Switch to next file in buffer and diff the real version
function NextDiff()
	wincmd h
	only
	n
	call OpenDiff()
endfunction
map <leader>cn :call NextDiff()<return>
" -- Dotfiles }}}

" ---- }}}

" vim:foldmethod=marker:foldlevel=0
