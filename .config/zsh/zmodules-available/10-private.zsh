#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/10-private.zsh
#
# Functions for a directory or private, encrypted data

# All variables and helper functions are nested to avoid exposing them
function pvt() {
	# Set variables
	local __pvt_repo="git@github.com:opsipolymath/private"
	local __pvt_key="4EB0765B"
	local __pvt_pdir="${HOME}/.private"
	local __pvt_fname="private.tgz.gpg"
	local __pvt_edir="${HOME}/.encrypted"
	local __pvt_efile="${__pvt_gdir}/${__pvt_fname}"

	# Prefer XDG for storing encrypted data if set
	if [[ -n "${XDG_DATA_HOME}" ]]; then
		__pvt_edir="${XDG_DATA_HOME}/private"
		__pvt_efile="${__pvt_edir}/${__pvt_fname}"
	fi

	# Don't colorize output unless STDERR is on the terminal
	local __red=""
	local __blue=""
	local __norm=""
	if [ -t 2 ]; then
		__blue="$(tput setaf 4)"
		__red="$(tput setaf 1)"
		__norm="$(tput sgr0)"
	fi

	# Helper function to output a success message
	function __pvt_s() {
		printf "%sSUCCESS%s: %s\n" "${__blue}" "${__norm}" "${@}"
	}

	# Helper function to output a warning
	function __pvt_w() {
		printf "%sWARNING%s: %s\n" "${__blue}" "${__norm}" "${@}" >&2
	}

	# Helper function output an error
	function __pvt_e() {
		printf "%sERROR%s: %s\n" "${__red}" "${__norm}" "${@}" >&2
	}

	# Helper function for git operations
	function __pvt_git() {
		git \
			--git-dir="${__pvt_edir}/.git" \
			--work-tree="${__pvt_edir}"    \
			"${@}"
	}

	# Helper function to confirm an action
	function __pvt_confirm() {
		__pvt_w "${@}"
		printf "\t Press '%sy%s' to confirm: " "${__red}" "${__norm}"
		local __pvt_response
		read -k1 __pvt_response
		# Delete message once complete
		tput cub $(tput cols) && tput el
		tput cuu1 && tput el
		if [[ "${__pvt_response:l}" = "y" ]]; then
			return 0
		fi
		return 1
	}

	# Helper function to check if directories are already set up
	function __pvt_issetup() {
		if [[ ! -d "${__pvt_pdir}" ]]; then
			return 1
		fi
		if [[ ! -d "${__pvt_edir}" ]]; then
			return 1
		fi
		if ! __pvt_git status &>/dev/null; then
			return 1
		fi
		return 0
	}

	# Helper function to pull remote and check for changes
	function __pvt_haschanges() {
		# Check if setup is done
		if ! __pvt_issetup; then
			__pvt_e "Setup not complete."
			return 1
		fi

		# Fetch data from git
		if ! __pvt_git fetch &>/dev/null; then
			__pvt_e "Failed to fetch remote data."
			return 1
		fi

		# Return false if there are no changes
		if [[ "$(__pvt_git diff origin/main 2>/dev/null)" = "" ]]; then
			__pvt_e "No changes on remote."
			return 1
		fi

		return 0
	}

	# Helper function to decrypt and extract archive
	function __pvt_decrypt() {
		if ! gpg -d "${__pvt_efile}" 2>/dev/null |
				tar -C "${__pvt_pdir}" -xz &>/dev/null; then
			__pvt_e "Failed to decrypt/extract data."
			return 1
		fi
		return 0
	}

	# Helper function removing all local files
	function __pvt_clean() {
		# Helper function to do the actual removing
		function __pvt_remove() {
			if ! rm -rf "${__pvt_pdir}" "${__pvt_edir}"; then
				__pvt_e "Failed to delete all local data."
				return 1
			fi
			return 0
		}

		# If forced, just do the removal
		if [[ "${1}" = "force" ]]; then
			__pvt_remove
			return $?
		fi

		# Confirm before removing data
		if __pvt_confirm "Delete all data?"; then
			if __pvt_remove; then
				__pvt_s "Local data deleted."
				return 0
			fi
			__pvt_e "Failed deleting local data."
			return 1
		fi

		__pvt_s "Nothing done."
		return 0
	}

	# Helper function to complete initial setup
	function __pvt_setup() {
		# Check if setup is already done
		if __pvt_issetup; then
			__pvt_e "Already setup."
			return 1
		fi

		# Create directories and clone repo
		mkdir -p "${__pvt_pdir}" "${__pvt_edir}"
		if ! git clone "${__pvt_repo}" "${__pvt_edir}" &>/dev/null; then
			__pvt_e "Failed to clone repo."
			__pvt_clean force
			return 1
		fi

		# Decrypt and extract data
		if ! __pvt_decrypt; then
			return 1
		fi

		__pvt_s "Setup complete."
		return 0
	}

	# Helper function to pull changes from git
	function __pvt_pull() {
		# Check for changes on remote
		if ! __pvt_haschanges; then
			return 1
		fi

		if ! __pvt_git pull &>/dev/null; then
			__pvt_e "Failed to pull changes."
			return 1
		fi

		if ! __pvt_decrypt; then
			__pvt_e "Failed to decrypt data."
			return 1
		fi

		__pvt_s "Encrypted data pulled from git."
		return 0
	}

	# Helper function to push changes from git
	function __pvt_push() {
		# Check for changes on remote and abort if there are
		if __pvt_haschanges &>/dev/null; then
			__pvt_e "Changes exist on remote. Aborting."
			return 1
		fi

		# Create encrypted tar archive
		if ! tar -czC "${__pvt_pdir}" . |
				gpg -er "${__pvt_key}" > "${__pvt_efile}"; then
			__pvt_e "Failed encrypting data."
			return 1
		fi

		# Commit and push changes
		if ! __pvt_git add "${__pvt_efile}" &>/dev/null; then
			__pvt_e "Failed adding file with git."
			return 1
		fi
		local __pvt_commit_msg="$(date +%Y%m%d%H%M)-$(hostname)"
		if ! __pvt_git commit -m "$__pvt_commit_msg}" &>/dev/null; then
			__pvt_e "Failed committing changes with git."
			return 1
		fi
		if ! __pvt_git push &>/dev/null; then
			__pvt_e "Failed pushing changes with git."
			return 1
		fi

		__pvt_s "Encrypted data pushed to git."
		return 0
}

	# Helper function to parse arguments and execute desired action
	function __pvt_exec() {
		case "${1}" in
			"clean")
				__pvt_clean "${2:=}"
				return $?
				;;
			"setup")
				__pvt_setup
				return $?
				;;
			"pull")
				__pvt_pull
				return $?
				;;
			"push")
				__pvt_push
				return $?
				;;
			"status")
				printf "pvt status:\n"
				printf "\tpvt dir: %20s" "${__pvt_pdir}"
				if [[ -d "${__pvt_pdir}" ]]; then
					printf "\tStatus: %sExists%s\n" "${__blue}" "${__norm}"
				else
					printf "\tStatus: %sMissing%s\n" "${__red}" "${__norm}"
				fi
				printf "\tenc dir: %20s" "${__pvt_edir}"
				if [[ -d "${__pvt_edir}" ]]; then
					printf "\tStatus: %sExists%s\n" "${__blue}" "${__norm}"
				else
					printf "\tStatus: %sMissing%s\n" "${__red}" "${__norm}"
				fi
				printf "\tgit repo: $(cut -d: -f2 <<< "${__pvt_repo}")"
				if __pvt_git status &>/dev/null; then
					printf "\tStatus: %sSuccess%s\n" "${__blue}" "${__norm}"
				else
					printf "\tStatus: %sFailure%s\n" "${__red}" "${__norm}"
				fi
				return 0
				;;
		esac

		# If no action was run, display help
		printf "%sERROR%s:'%spvt%s' requires a valid action:\n" \
			"${__red}" "${__norm}" "${__blue}" "${__norm}" >&2
		printf "\t'%spvt setup%s' : initial setup\n" \
			"${__blue}" "${__norm}" >&2
		printf "\t'%spvt pull%s' : pull and decrypt changes\n" \
			"${__blue}" "${__norm}" >&2
		printf "\t'%spvt push%s' : encypt and push changes\n" \
			"${__blue}" "${__norm}" >&2
		printf "\t'%spvt clean%s' : delete all local data\n" \
			"${__blue}" "${__norm}" >&2
		return 1
	}

	# Execute provided command and store return value
	__pvt_exec "$@"
	local __pvt_return="$?"

	unfunction __pvt_s __pvt_w __pvt_e __pvt_git __pvt_confirm       \
		__pvt_issetup __pvt_haschanges __pvt_decrypt __pvt_clean \
		__pvt_setup __pvt_pull __pvt_push __pvt_exec

	return "${__pvt_retun}"
}
