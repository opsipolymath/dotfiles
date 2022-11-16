#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/20-dotfiles.sh
#
# Settings, functions and aliases related to dotfiles

# Set environment variables
DOTFILES="${HOME}/.dotfiles"
# Prefer XDG if set
if [[ -n "${XDG_CONFIG_HOME}" ]]; then
	DOTFILES="${XDG_CONFIG_HOME}/dotfiles"
fi

# Export variables
export DOTFILES

# Setup alias for dotfiles
alias dotfiles="git --git-dir=\"${DOTFILES}\" --work-tree=\"${HOME}\""

# Shortened function for simple actions
function dots() {
	# If called with no params, display status and exit
	if (( $# < 1 )); then
		dotfiles status
		return $?
	fi

	# If called simply to push changes, make a commit and push
	if [[ "$1" == "push" ]]; then
		git commit -m "$(date)"
		git push
		return $?
	fi

	# Otherwise pass params to the git alias
	dotfiles "$@"
}
