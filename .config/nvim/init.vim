let s:config_dir = expand('<sfile>:p:h')
for s:part in ['plugins', 'user-interface', 'spelling-and-completion', 'misc-options', 'terminal', 'keymaps', 'vimwiki', 'custom-functions']
	execute 'source' fnameescape(s:config_dir . '/conf.d/' . s:part . '.vim')
endfor
unlet s:part
