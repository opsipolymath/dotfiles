" Vim syntax file
" Language: rofi configuration file

if exists("b:current_syntax")
  finish
endif

" let b:main_syntax = 'css'
" let b:is_css = 1
" runtime! syntax/css.vim

syn match rasiComment   "^//.*"
syn match rasiSelector  "^.* {$"
syn match rasiSelector  "^}$"
syn match rasiGroup     '\[ .* \]'
syn match rasiGroup     '( \+[0-9]\+, \+[0-9]\+, \+[0-9]\+, [0-9]\+ % )'
syn match rasiString    '\<[a-zA-z]\+[^:]\>'
syn match rasiString    '".*"'
syn match rasiReference '@[a-z\-]\+'
syn match rasiReference '\<rgba\>'
syn match rasiNumber    '\<[0-9]\+\>'
syn match rasiNumber    '\<[0-9]\+px\>'
syn match rasiNumber    '\<[0-9]\+em\>'

hi def link rasiComment Comment
hi def link rasiSelector Structure
hi def link rasiReference String
hi def link rasiGroup Statement
hi def link rasiString String
hi def link rasiRGB Statement
hi def link rasiNumber Number
