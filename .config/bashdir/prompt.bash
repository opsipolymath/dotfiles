# "${XDG_CONFIG_HOME}/bashdir/prompt.bash
#
# Sets the bash prompt

if [[ -z "${__NORM}" ]]; then
	__NORM="$(tput setaf 4)"
	__INFO="$(tput setaf 2)"
	__ERROR="$(tput setaf 1)"
	__RESET="$(tput sgr0)$(tput cnorm)"
fi

function __DCOLOR() {
	__COLOR="${__INFO}"
	[[ ! -w "$PWD" ]] && __COLOR="${__ERROR}"
	printf '%s' "${__COLOR}"
}

function __UCOLOR() {
	__COLOR="${__INFO}"
	(( EUID == 0 )) && __COLOR="${__ERROR}"
	printf '%s' "${__COLOR}"
}

function __PCOLOR() {
	__COLOR="${__NORM}"
	(( EUID == 0 )) && __COLOR="${__ERROR}"
	printf '%s' "${__COLOR}"
}

export PS1="\[${__NORM}\]┌[\[\$(__DCOLOR)\]\w\[${__NORM}\]]\n└[\[\$(__UCOLOR)\]\u\[${__INFO}\]@\h\[${__NORM}\]] \[\$(__PCOLOR)\]\$ \[${__RESET}\]"
