#!/usr/bin/zsh

# Attempt to bootstrap dotfiles; may cause all running zshells to exit or
# behave unpredictably if SIGUSER1 is not trapped explicitly by them.

# Define global variables
readonly __dotdir="${HOME}/.config/dotfiles"
readonly __username="opsipolymath"
readonly __reponame="dotfiles"
readonly __repo="https://github.com/${__username}/${__reponame}.git"

# __dots - Call git with options for using dotfiles bare repo
# Arguments:
#     array - git options, parameters and arguments
__dots() {
	if /usr/bin/git --git-dir="${__dotdir}" --work-tree="${HOME}" "$@"; then
		return 0
	fi
	return 1
}

# __set_upstream - Switch upstream to ssh for future usage
# Arguments:
#     none
__set_upstream() {
	__dots remote set-url origin "${__repo}"
	if __dots checkout >/dev/null 2>&1; then
		return 0
	fi
	printf "ERROR: Failed checking out dotfiles.\n"
	printf " => Check for conflict and try again with: 'dots checkout'\n"
	alias dots="git --git-dir=${HOME}/${__dotdir} --work-tree=${HOME}"
	exit 1
}

# __enable_base_modules - Creates symlinks to enable a base set of zmodules
# Arguments:
#     none
__enable_base_modules() {
	pushd "${HOME}/.config/zsh/zmodules-enabled"
	ln -st . ../zmodules-available/{01-*,05-*} >/dev/null 2>&1
	popd
}
