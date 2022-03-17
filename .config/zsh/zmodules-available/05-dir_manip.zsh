#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/05-dir_manip.zsh
#
# Settings related to how zsh handles directories

# Limit directory history
export DIRSTACKSIZE=48

# cd into directories if name only is passed
setopt autocd
# Use pushd automatically when using cd
setopt autopushd
# Don't print the dirstack with every cd
setopt pushdsilent
# Go home with cd instead of swapping with last in dirstack
setopt pushdtohome
