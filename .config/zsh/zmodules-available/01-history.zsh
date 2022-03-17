#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/10-history.zsh
#
# Shell history settings configuration

# Set history-related environment variables
export HISTFILE="${ZDOTDIR}/.histfile"
export HISTSIZE=200000
export SAVEHIST=100000

# Append commands to history as they are enetered without waiting
setopt INC_APPEND_HISTORY
# Only keep the newest version of duplicates
setopt HIST_IGNORE_ALL_DUPS
# Don't save commands starting with a space to history
setopt HIST_IGNORE_SPACE
# Remove superfluous blanks before saving command to history
setopt HIST_REDUCE_BLANKS
# Reload line when expanding history rather than executing
setopt HIST_VERIFY
