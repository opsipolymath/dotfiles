#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/10-private.zsh
#
# Functions for a directory or private, encrypted data

# Set environment variables
ENC_REPO="opsipolymath/private"
ENC_KEY="154D6DE5"
PVT_DIR="${HOME}/.private"      # Overridden by XDG if configured
ENC_DIR="${PVT_DIR}/.encrypted" # Overridden by XDG if configured

# Prefer XDG for directory location if set
if [[ -n "${XDG_DATA_HOME}" ]]; then
	PVT_DIR="${XDG_DATA_HOME}/private"
fi
ENC_DIR="${PVT_DIR}/$( basename "${ENC_DIR}" )"

# Export variables
export ENC_REPO ENC_KEY PVT_DIR ENC_DIR

# Wrapper function for easier calling
function pvt() {
	# By default, don't colorize output
	__red="" && __blue="" && __norm=""

	# If STDERR is on the terminal, define colors
	if [ -t 2 ]; then
		__blue="$(tput setaf 4)"
		__red="$(tput setaf 1)"
		__norm="$(tput sgr0)"
	fi

	# Run specified action
	case "$1" in
		"setup")
			__git_e-setup
			unset __red __blue __norm
			return $?
			;;
		"pull")
			__git_e-pull
			unset __red __blue __norm
			return $?
			;;
		"push")
			__git_e-push
			unset __red __blue __norm
			return $?
			;;
	esac

	# If no action was run, output an error
	printf "%sERROR:%s pvt requires a valid action:\n" \
		"${__red}" "${__norm}" >&2
	printf "\t'%spvt setup%s': initial setup\n" \
		"${__blue}" "${__norm}" >&2
	printf "\t'%spvt pull%s' : pull changes and decrypt files\n" \
		"${__blue}" "${__norm}" >&2
	printf "\t'%spvt push%s' : encrypt files and push changes\n" \
		"${__blue}" "${__norm}" >&2
	return 1
}

# Helper function for git operations
function __git_e() {
	git --git-dir="${ENC_DIR}/.git" --work-tree="${ENC_DIR}"
}

# Function to verify directories exist
function __git_e-check() {
	if [[ ! -d "${PVT_DIR}" ]]; then
		printf "%sERROR%s: Private directory missing.\n" \
			"${__red}" "${__norm}" >&2
		return 1
	fi
	if [[ ! -d "${ENC_DIR}" ]]; then
		printf "%sERROR%s: Encrypted directory missing..\n" \
			"${__red}" "${__norm}" >&2
		return 1
	fi
	return 0
}

# Setup encrypted directories and clone the repo
function __git_e-setup() {
	if __git_e-check &>/dev/null; then
		printf "%sERROR%s: Encrypted repo already setup.\n" \
			"${__red}" "${__norm}" >&2
		return 1
	fi
	mkdir -p "${ENC_DIR}" &>/dev/null
	if ! git clone "git@github.com:${ENC_REPO}" \
			"${ENC_DIR}" &>/dev/null; then
		printf "%sERORR%s: Failed to clone repo.\n" \
			"${__red}" "${__norm}" >&2
		return 1
	fi
	__git_e-decrypt
}

# Pull and decrypt the private data
function __git_e-pull() {
	if ! __get_e-check; then
		return 1
	fi
	if ! git --git-dir="${ENC_DIR}/.git" pull; then
		printf "%sERROR%s: Failed to pull repo.\n" \
			"${__red}" "${__norm}" >&2
		return 1
	fi
	gpg -d "${ENC_DIR}"/private.tgz.gpg &>/dev/null |
		tar -C "${PVT_DIR}" -xz &>/dev/null
}

# Encrypt and push the private data
function __git_e-push() {
	if ! __git_e-check; then
		return 1
	fi
	pushd "${PVT_DIR}"
	__enc_excl="./$(basename "${ENC_DIR}")"
	__enc_file="${ENC_DIR}/private.tgz.gpg"
	tar -czC "${PVT_DIR}" --exclude="${__enc_excl}" . |
		gpg -ser "${ENC_KEY}" --yes -o "${__enc_file}" &&
		__git_e add "${__enc_file}" &>/dev/null &&
		__git_e commit -m "$(date)" &>/dev/null &&
		__git_e push &>/dev/null
	unset __enc_excl __enc_file
	popd
}
