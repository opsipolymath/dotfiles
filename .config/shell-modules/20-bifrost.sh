# {XDG_CONFIG_HOME}/shell-modules/20-bifrost.sh
#
# Colorful, fun way to call ssh

# bifrost() verifies at least a target is specified, but just passes
# all params to ssh without modification
function bifrost () {
	tput civis
	tput sc
	tput setaf 3
	printf "   Heimdallr! Open the Bifröst!"
	tput sgr0
	sleep 0.7
	tput rc
	tput el

	# Display an error if no target is given
	if [[ $# < 1 ]]; then
		tput setaf 1
		printf "   You have to tell me where you're going!"
		tput sgr0
		sleep 0.7
		tput rc
		tput el
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

	# Update tty for password entry
	echo UPDATESTARTUPTTY | gpg-connect-agent &>/dev/null

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
