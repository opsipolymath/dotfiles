# ${XDG_CONFIG_HOME}/shell-modules/05-update.sh
#
# Collection of aliases and functions for package mangement

# Sign and build in chroot by default
alias aursync="/usr/bin/aur sync --no-view --sign --remove --chroot"

# Do a full system update from official repos and, optionally, the AUR
function update() {
	if [[ "aur" == "$1" ]]; then
		! pacman -Qq aurutils &>/dev/null &&
			printf 'ERROR: aurutils not installed\n' &&
			return 1
		aursync -u || return $?
	fi
	printf 'Checking for updates... '
	local __updates="$( checkupdates )"
	if [[ -z "${__updates}" ]]; then
		printf "none available.\n"
		return 0
	fi
	printf 'done\n'
	if echo "${__updates}" | grep -q 'archlinux-keyring'; then
		sudo pacman -Sy archlinux-keyring && sudo pacman -Su
		return "$?"
	fi
	sudo pacman -Syu
	return "$?"
}

# Does some basic checks and call repo-add appropriately
function pkgadd() {
	# Verify GPG is ready
	if ! printenv GPGKEY &>/dev/null; then
		printf 'ERROR: GPGKEY environment variable not set\n'
		return 1
	fi

	# Get repo details
	local __REPO_PARAMS
	__REPO_PARAMS="$(aur repo $@)" || return 1
	local __REPO_NAME="$(echo "$__REPO_PARAMS" | awk -F: 'FNR==1{printf $2}')"
	local __REPO_ROOT="$(echo "$__REPO_PARAMS" | awk -F: 'FNR==2{printf $2}')"
	local __REPO_PATH="$(echo "$__REPO_PARAMS" | awk -F: 'FNR==3{printf $2}')"
	# Drop repo name specification if it was provided
	[[ "-d" =~ "$1" ]] && shift 2

	# Sign and copy package files if they need to be
	local p __pkgdir
	for p in $@; do
		[[ ! -f "${p}".sig ]] && gpg --detach-sign "${p}"
		__pkgdir="$(realpath "$p")"
		[[ "${__pkgdir}" != "${__REPO_ROOT}" ]] &&
			/usr/bin/cp -i "${p}" "${p}.sig" "${__REPO_ROOT}"
	done

	# Add to repo
	repo-add --sign "${__REPO_PATH}" $@
}

# Does some basic checks and call repo-remove appropriately
function pkgdel() {
	# Verify GPG is read
	if ! printenv GPGKEY &>/dev/null; then
		printf 'ERROR: GPGKEY environment variable not set\n'
		return 1
	fi

	# Get repo details
	local __REPO_PARAMS
	__REPO_PARAMS="$(aur repo $@)" || return 1
	local __REPO_NAME="$(echo "$__REPO_PARAMS" | awk -F: 'FNR==1{printf $2}')"
	local __REPO_ROOT="$(echo "$__REPO_PARAMS" | awk -F: 'FNR==2{printf $2}')"
	local __REPO_PATH="$(echo "$__REPO_PARAMS" | awk -F: 'FNR==3{printf $2}')"
	# Drop repo name specification if it was provided
	[[ "-d" =~ "$1" ]] && shift 2

	# Remove the packages (prefer repoctl as it also removes files
	repoctl remove "${__REPO_PATH}" $@ || return 1
	# repoctl won't resign packages though
	aurdbsign
	return 0
}

# Check for potentially orphaned package files
# NOTE: -debug pages are generally owned by parents, so they are not checked
function pkgverify() {
	local p
	for p in /var/cache/pacman/custom/*.pkg.tar.zst; do
		pkgname="$(basename $p | rev | cut -d'-' -f1,2,3 --complement | rev )"
		[[ ${pkgname: -5} == "debug" ]] && continue
		pacman -Qq $pkgname &>/dev/null || not_installed+=( $pkgname )
	done

	if (( ${#not_installed[@]} > 0 )); then
		printf 'The following packages are not installed:\n'
		printf '\t%s\n' "${not_installed[@]}"
		return 1
	fi
	printf 'No superfluous packages exist in the local repository.\n'
	return 0
}

# Mismanagement of databases (including errors) can result in invalid signatures;
# this function will remove all incorrect signatures and resign all database files.
# To avoid this problem in future, ensure repo-add and repo-remove are always used
# with the '--sign' flag, or use pkgadd and pkgdel.
function aurdbsign() {
	if ! printenv GPGKEY &>/dev/null; then
		printf 'ERROR: GPGKEY environment variable not set\n'
		return 1
	fi
	local __REPO_PARAMS
	__REPO_PARAMS="$(aur repo $@)" || return 1
	local __REPO_NAME="$(echo "$__REPO_PARAMS" | awk -F: 'FNR==1{printf $2}')"
	local __REPO_ROOT="$(echo "$__REPO_PARAMS" | awk -F: 'FNR==2{printf $2}')"
	local __REPO_PATH="$(echo "$__REPO_PARAMS" | awk -F: 'FNR==3{printf $2}')"
	rm "${__REPO_ROOT}/${__REPO_NAME}".{db,files}*sig 2>/dev/null
	local __db_files=( "${__REPO_ROOT}/${__REPO_NAME}".{db,files}* )
	local __db_file
	for __db_file in ${__db_files[@]}; do
		gpg --detach-sign --no-armor --batch -u $GPGKEY "${__db_file}"
	done
}

# If aurutils and repoctl aren't installed, generate errors instead
# NOTE: repoverify doesn't rely on any aurutil libraries and can be left
if ! pacman -Qq aurutils repoctl &>/dev/null; then
	alias aursync="printf 'ERROR: aurutils is not installed\n'; return 2"
	alias aurdbsign="printf 'ERROR: aurutils is not installed\n'; return 2"
	alias repoadd="printf 'ERROR: aurutils is not installed\n'; return 2"
	alias repodel="printf 'ERROR: aurutils is not installed\n'; return 2"
fi
