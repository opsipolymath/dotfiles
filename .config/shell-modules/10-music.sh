# {XDG_CONFIG_HOME}/shell-modules/10-music.sh
#
# Functions related to music applications

function ncmpcpp() {
	if ! systemctl is-active --quiet --user mopidy; then
		printf 'ERROR: Mopidy is not running.\n'
		printf 'Should I start it? '
		reply=$(bash -c "read -n1 r; echo \${r,,}")
		printf '\n'
		if [[ y != ${reply} ]]; then
			return
		fi
		/usr/bin/systemctl --user start mopidy
	fi
	( /usr/bin/alacritty -e cava & )
	/usr/bin/ncmpcpp -q
	/usr/bin/killall cava
}

alias nc="ncmpcpp"
alias ncmp_help="brave 'https://pkgbuild.com/~jelle/ncmpcpp/'"
