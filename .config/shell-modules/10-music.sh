# {XDG_CONFIG_HOME}/shell-modules/10-music.sh
#
# Functions related to music applications

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
