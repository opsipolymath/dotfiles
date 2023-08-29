# {XDG_CONFIG_HOME}/shell-modules/10-music.sh
#
# Functions related to music applications

function alarm() {
	# Use 'at' as a simple alarm clock
	if (( $# < 1 )); then
		printf 'ERROR: Insufficient arguments.\m'
		printf '\tUsage:   alarm [time] [file]\n'
		printf '\tExample: alarm 12:00 alarm.mp3\n'
		return 1
	fi
	if (( $# > 1 )); then
		echo "mpg123 \"$2\"" | at $1
		return 0
	fi
	[[ ! -f "$HOME/Audio/Alarms/default" ]] &&
		printf 'ERROR: No alarm defined.\n' &&
		return 1
	echo "mpg123 \"$HOME/Audio/Alarms/default\"" | at "$1"
}

function ncmpcpp() {
	# Store the current desktop layout, switch to wide,
	# launch cava, tab back to original window, and launch
	# ncmpcpp.
	__layout="$(bsp-layout get)"
	bsp-layout set wide &>/dev/null && sleep 0.5
	( /usr/bin/alacritty -e cava & ) && sleep 0.5
	bspc node -f prev.local.!hidden.window
	/usr/bin/ncmpcpp -q $@

	# On shutdown, kill cava and restore original layout
	# if it hasn't been changed
	/usr/bin/killall cava &>/dev/null
	[[ "wide" == "$(bsp-layout get)" ]] &&
		bsp-layout set $__layout &>/dev/null
}

alias nc="ncmpcpp"
