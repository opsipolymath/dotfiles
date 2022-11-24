#!/bin/zsh

# ${ZDOTDIR}/zmodules-enabled/99-autofetch.zsh
#
# Fetch changes to dotfiles silently in the background
# NOTE: requires custom read-only deplay key exists

if [[ -f '${XDG_CONFIG_HOME}/ssh/opsipolymath-dotfiles.key' ]]; then
	GIT_SSH_COMMAND="${GIT_SSH_COMMAND} -i '${XDG_CONFIG_HOME}/ssh/opsipolymath-dotfiles.key'" git --git-dir="${XDG_CONFIG_HOME}/dotfiles" --work-tree="${HOME}" fetch &!
fi
