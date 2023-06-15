#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/05-aliases.zsh
#
# General aliases

# Fix sudo so alias expansion works
alias sudo="/usr/bin/sudo "

# Default options for commonly used commands
alias cp="cp -v"
alias mv="mv -v"
alias acp="/usr/bin/advcp -g"
alias amv="/usr/bin/advmv -g"
alias df="/usr/bin/df -h"
alias du="/usr/bin/du -h"
alias grep="grep --color=auto"
alias ls="/usr/bin/ls --color=auto -hv --group-directories-first"
alias sort="/usr/bin/sort -h"

# Shortened aliases for common applications
alias mkdiff="diff -U 99999"
alias nv="/usr/bin/nvim"
alias em="emacsclient -c -a 'emacs'"
alias emacs="emacsclient -c -a 'emacs'"
alias se="/usr/bin/sudoedit"
alias aursync="/usr/bin/aur sync --no-view --sign --remove --chroot"
alias info="/usr/bin/pinfo"
alias steam="/usr/bin/steam -nochatui -nofriendsui -silent"

# Make startx use dbus properly
alias startx="/usr/bin/dbus-launch --exit-with-session /usr/bin/startx \"${XINITRC}\" &>/dev/null"

# Set ssh aliases to use custom config file if defined
if [[ -n "${SSH_CONFIG}" ]]; then
	alias ssh="/usr/bin/ssh -F \"${SSH_CONFIG}\""
	alias scp="/usr/bin/scp -F \"${SSH_CONFIG}\""
fi
