#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/20-bifrost.zsh
#
# Colorful, fun way to call ssh

# bifrost() verifies at least a target is specified, but just passes
# all params to ssh without modification
function bifrost () {
	printf "Heimdallr! Open the Bifröst!\n"

	# Display an error if no target is given
	if [[ $# < 1 ]]; then
		tput setaf 1
		printf "You have to tell me where are you going!\n"
		tput sgr0
		return 1
	fi

	# Output the bifrost 4 coloured tiles at a time
	function __bifrost_section() {
		for i in {1..4}; do
			printf "≡"
			sleep 0.03s
		done
	}

	# Display the bifröst
	for __color in 1 214 3 2 4 6 5; do
		tput setaf "${__color}"
		__bifrost_section
	done
	unset __color
	printf "\n"
	tput sgr0

	# Use custom SSH config if set
	if [[ -n "${SSH_CONFIG}" ]]; then
		/usr/bin/ssh -F "${SSH_CONFIG}" "$@"
		return $?
	fi

	# Otherwise, use defaults
	/usr/bin/ssh "$@"
	return $?
}

# Define some aliases
alias ssh="bifrost"
alias bf="bifrost"
