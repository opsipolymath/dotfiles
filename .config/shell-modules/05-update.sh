# ${XDG_CONFIG_HOME}/shell-modules/05-update.sh
#
# Collection of aliases and functions for package mangement

alias aursync="/usr/bin/aur sync --no-view --sign --remove --chroot"

function update() {
	printf 'Checking for updates... '
	__updates="$( checkupdates )"
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

function aurdbsign() {
	# Get repo directory and filename
	__repo_dir="$(grep 'file:///' /etc/pacman.conf | sed 's|.*///|/|')"
	__repo_name="$(basename "${__repo_dir}")"
	__repo_file="${__repo_dir}/${__repo_name}.db.tar"

	# Remove existing DB signatures and resign
	pushd "${__repo_dir}"
	for f in "${__repo_name}".db*.sig; do
		rm "$f"
	done
	for f in "${__repo_name}".files*.sig; do
		rm "$f"
	done
	for f in "${__repo_name}".db*; do
		gpg --detach-sign "$f"
	done
	for f in "${__repo_name}".files*; do
		gpg --detach-sign "$f"
	done
	popd
}

function aurdel() {
	# Needs at least one argument
	(( $# < 1 )) &&
		printf 'ERROR: No packages provided for removal\n' &&
		return 1

	# Get repo directory and filename
	__repo_dir="$(grep 'file:///' /etc/pacman.conf | sed 's|.*///|/|')"
	__repo_name="$(basename "${__repo_dir}")"
	__repo_file="${__repo_dir}/${__repo_name}.db.tar"

	# Get list of package files matching parameters
	for p in "$@"; do
		__pkgs=( /var/cache/pacman/custom/"$p"*.pkg.tar.zst )
		# Make sure at least package file matches
		(( ${#__pkgs} < 1 )) &&
			printf 'ERROR: No matching package files found.\n' &&
			return 1
		# Remove packages
		repo-remove "${__repo_file}" "$p"
		rm "${__pkgs[@]}"
		unset __pkgs
	done

	# Resign DB files
	aurdbsign
}

# Check if any packages in the custom repo are not installed locally
function checkaurinstalled() {
	__not_installed=( )
	for p in /var/cache/pacman/custom/*.pkg.tar.zst; do
		pkgname="$(basename $p | rev | cut -d'-' -f1,2,3 --complement | rev )"
		[[ ${pkgname: -5} == "debug" ]] && continue
		pacman -Qq $pkgname &>/dev/null || __not_installed+=( $pkgname )
	done

	(( ${#__not_installed[@]} > 0 )) &&
		printf 'The following packages are not installed:\n' &&
		printf '\t%s\n' "${__not_installed[@]}"
	}
