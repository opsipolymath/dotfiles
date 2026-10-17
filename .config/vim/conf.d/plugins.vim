" Optional Plugin Layer -------------------------------------------------------
function! s:LoadPlugins() abort
	let l:config_home = empty($XDG_CONFIG_HOME)
		\ ? expand('~/.config')
		\ : expand($XDG_CONFIG_HOME)

	let l:data_home = empty($XDG_DATA_HOME)
		\ ? expand('~/.local/share')
		\ : expand($XDG_DATA_HOME)

	let l:plug_vim = l:config_home . '/vim/autoload/plug.vim'
	let l:plugged_dir = l:data_home . '/vim/plugged'
	let l:installed_plug = 0

	if !filereadable(l:plug_vim)
		let l:output = system([
			\ 'curl',
			\ '-fsSLo', l:plug_vim,
			\ '--create-dirs',
			\ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
			\ ])

		if v:shell_error
			echohl ErrorMsg
			echom 'vim-plug install failed:'
			echom l:output
			echohl None
			return
		endif

		if !filereadable(l:plug_vim)
			echom 'vim-plug install failed; skipping optional plugins'
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
		"Plug 'arcticicestudio/nord-vim'
	call plug#end()

	if l:installed_plug
		augroup PlugBootstrap
			autocmd!
			autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
		augroup END
	endif
endfunction

let s:plugin_hosts = [
	\ 'jarnvidr',
	\ 'valhalla',
	\ ]

let s:load_plugins = index(s:plugin_hosts, hostname()) >= 0
if s:load_plugins
	call s:LoadPlugins()
endif
