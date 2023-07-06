# ${XDG_CONFIG_HOME}/shell-modules/05-update.sh
#
# A more efficient function for updating Archlinux

function update() {
	__updates="$( checkupdates )"
	if [[ -z "${__updates}" ]]; then
		printf "No updates available.\n"
		return 0
	fi
	if echo "${__updates}" | grep -q 'archlinux-keyring'; then
		sudo pacman -Sy archlinux-keyring && sudo pacman -Su
		return "$?"
	fi
	sudo pacman -Syu
	return "$?"
}
