" Optional plugin module, loaded by vimrc only if this file is present. On the
" hosts listed at the end, it installs vim-plug if missing and loads plugins.

" Plugins ---------------------------------------------------------------------

" True if FILE is a usable vim-plug, which defines plug#begin(). A partial
" download, or any other broken file, is not.
function! s:IsPlugVim(file) abort
	return filereadable(a:file)
		\ && match(readfile(a:file), '^\s*function!\=\s\+plug#begin(') >= 0
endfunction

function! s:LoadPlugins() abort
	let l:config_home = empty($XDG_CONFIG_HOME)
		\ ? expand('~/.config')
		\ : expand($XDG_CONFIG_HOME)

	let l:data_home = empty($XDG_DATA_HOME)
		\ ? expand('~/.local/share')
		\ : expand($XDG_DATA_HOME)

	" vim-plug itself lives with the configuration; the plugins it fetches are
	" data, kept out of the dotfiles.
	let l:plug_vim = l:config_home . '/vim/autoload/plug.vim'
	let l:plugged_dir = l:data_home . '/vim/plugged'
	let l:installed_plug = 0

	" Download vim-plug on first use, or again if the existing file is broken.
	" The download goes to a separate file and is renamed into place only once
	" complete and valid, so an interrupted download never leaves a plug.vim
	" that later starts would trust.
	if !s:IsPlugVim(l:plug_vim)
		let l:download = l:plug_vim . '.download'
		let l:output = system([
			\ 'curl',
			\ '-fsSLo', l:download,
			\ '--create-dirs',
			\ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
			\ ])
		let l:curl_failed = v:shell_error

		if l:curl_failed || !s:IsPlugVim(l:download) || rename(l:download, l:plug_vim) != 0
			call delete(l:download)
			echohl ErrorMsg
			echom 'vim-plug install failed; skipping optional plugins'
			if l:curl_failed && !empty(l:output)
				echom l:output
			endif
			echohl None
			return
		endif

		let l:installed_plug = 1
	endif

	execute 'source' fnameescape(l:plug_vim)

	call plug#begin(l:plugged_dir)
		Plug 'junegunn/fzf'
		Plug 'junegunn/fzf.vim'
		Plug 'junegunn/vim-easy-align'
		Plug 'preservim/nerdtree'
		Plug 'ap/vim-css-color'
		Plug 'lervag/vimtex'
		Plug 'thisisrandy/vim-outdated-plugins'
	call plug#end()

	" After a fresh vim-plug install, install the plugins once Vim has started,
	" then reload the configuration so they take effect in this session.
	if l:installed_plug
		augroup PlugBootstrap
			autocmd!
			autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
		augroup END
	endif
endfunction

" Hosts that load plugins; Vim runs without them everywhere else
let s:plugin_hosts = [
	\ 'jarnvidr',
	\ 'valhalla',
	\ ]

let s:load_plugins = index(s:plugin_hosts, hostname()) >= 0
if s:load_plugins
	call s:LoadPlugins()
endif
