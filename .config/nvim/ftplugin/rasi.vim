" Vim filetype plugin file
" Language: rofi configuration file
" Maintainer: Aeryxium <aeryxium+nvim@gmail.com>
" Latest Revision: 03 April 2021

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal commentstring=//\ %s,;\ //\ %s
set iskeyword+=:
set iskeyword+=-
