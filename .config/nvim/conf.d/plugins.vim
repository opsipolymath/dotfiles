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
	Plug 'folke/zen-mode.nvim'
	Plug 'habamax/vim-asciidoctor'
	Plug 'itchyny/lightline.vim'
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'junegunn/vim-easy-align'
	Plug 'lervag/vimtex'
	Plug 'mzlogin/vim-markdown-toc'
	Plug 'preservim/nerdtree'
	Plug 'sphamba/smear-cursor.nvim'
	Plug 'thisisrandy/vim-outdated-plugins'
	Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
	Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
call plug#end()
" -- Install Plugins }}}

" -- Plugin Settings {{{
" nord-vim
" let g:nord_uniform_status_lines = 1

lua require('smear_cursor').setup({
	\ enabled = true,
	\ stiffness = 0.7,
	\ trailing_stiffness = 0.6,
	\ stiffness_insert_mode = 0.8,
	\ trailing_stiffness_insert_mode = 0.8,
	\ distance_stop_animating = 0.1
	\})

" lightline
let g:lightline = {
	\ 'colorscheme': 'nord',
	\ 'active': {
	\     'right': [ [ 'lineinfo'], ['percent'], ['filetype'] ] },
	\ 'component': {
	\     'filename': '%F',
	\     'lineinfo': '%3l:%-2v'}
	\ }

" vimtex
let g:vimtex_view_method = 'general'
let g:vimtex_quickfix_mode = 0
let g:tex_conceal = 'abdmg'

" vimwiki
let g:vimwiki_list = [ {
	\ 'path': '~/notebook/content',
	\ 'index': '_index',
	\ 'syntax': 'markdown',
	\ 'ext': '.md',
	\ 'links_space_char': '-'
	\ }, {
	\ 'path': '~/lyceum/content',
	\ 'index': '_index',
	\ 'syntax': 'markdown',
	\ 'ext': '.md',
	\ 'links_space_char': '-',
	\ 'diary_rel_path': '/inbox/quick-notes',
	\ 'diary_index': 'overview',
	\ 'diary_header': 'Quick Notes'
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
