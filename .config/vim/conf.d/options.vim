" General Settings ------------------------------------------------------------


" Enable True Color (24-bit RGB) support in Vim
if has('termguicolors')
	set termguicolors
endif

"colorscheme nord
set background=dark
hi Visual cterm=inverse ctermfg=green

" turn on syntax highlighting
syntax enable
syntax on

" enable word wrapping but break at breakpoints
set wrap linebreak

" automatically load changed files
set autoread

" show the filename in the window titlebar
set title

" set encoding
set encoding=utf-8

" directories for swp files
set backupdir=~/.cache/vim/backup
set directory=~/.cache/vim/backup

" display incomplete commands at the bottom
set showcmd

" turn on line numbers and highlight current line number
set number relativenumber
set cursorline

" set line length warning
set colorcolumn=80

" ignore whitespace in diff mode
set diffopt+=iwhite

" be able to arrow key and backspace across newlines
set whichwrap=bs<>[]

" show '>   ' at the beginning of lines that are automatically wrapped
set showbreak=>\ \ \ 

" show Tabs and Spaces
set list listchars=nbsp:¬,tab:»·,trail:·,extends:>

" highlight trailing whitespace
hi ExtraWhitespace ctermbg=red guifg=red
match ExtraWhitespace /\s\+$\| \+\ze\t \| [^\t]\zs\t\+/
autocmd colorscheme * hi ExtraWhitespace ctermbg=red guifg=red

" conceal text completely unless a replacement is defined
set conceallevel=2


" highlight all matches of a search, and show matches as they are typed
set hlsearch incsearch

" ignore case when searching unless pattern contains uppercase
set ignorecase smartcase

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" keep cursor line vertically centered
set scrolloff=999

" split Below or Right instead of Above or Left
set splitbelow splitright

" status Line
set laststatus=2

" set indentation
set shiftwidth=8
set tabstop=8
set softtabstop=8
set noexpandtab

" autoindent based on previous line
set autoindent smartindent copyindent

" set spelling
set spelllang=en_ca,fr
set spell

" show matching brackets/parens/etc
set showmatch

" disable automatic commenting on newline
augroup autocomments
	autocmd!
	autocmd FileType * setlocal fo-=c fo-=r fo-=o
augroup END

" use an undofile
set undofile

" fix escape key delay
set timeoutlen=1000 ttimeoutlen=0

" disable mouse
set mouse=

" use global and selection clipboard
set clipboard^=unnamed,unnamedplus
