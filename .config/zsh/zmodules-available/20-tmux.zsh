#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/20-tmux.zsh
#
# Various tmux helper functions

# If not in a TMUX instance, treat CTRL-D as normal
bindkey "^D" .backward-kill-line

# Prevent tmux from closing with last pane
if [ -n "$TMUX" ]; then
	# Detach only if there is only one pane/window open
	__exit_maybe() {
		[ "$(tmux list-panes   | wc -l)" -gt 1 ] && exit
		[ "$(tmux list-windows | wc -l)" -gt 1 ] && exit
		tmux detach-client
	}

	# Define a new keymap and bind it to CTRL-D
	zle -N __exit_maybe __exit_maybe
	bindkey -s "^D" ""
	bindkey "" __exit_maybe
fi

# Connect to existing default session or start one
function tmux() {
	# If attach without specifying session or no tmux command used
	if (( $# == 0 )) || ( (( $# == 1 )) && [[ "$@" == "a" ]] ); then
		# Attach to existing session if it exists
		if /usr/bin/tmux ls 2>/dev/null | grep -q ^"${USER}"; then
			/usr/bin/tmux a -t "${USER}"
			return
		fi
		# Otherwise launch a new session
		/usr/bin/tmux new-session -s "${USER}"
		return
	fi

	# If a different tmux command is called, just execute it
	/usr/bin/tmux "$@"
}
