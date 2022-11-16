#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/10-ssh_protection.zsh
#
# Protect problematic commands when connected via ssh

autoload -Uz colors
colors

# Confirm poweroff if connected via ssh
function poweroff() {
	# Print warning and confirm if in SSH session
	if [[ -n "$SSH_TTY" ]]; then
		print -P "%F{red}Connected via ssh..."
		if read -sq "?   Really power off the remote machine? "; then
			print -P "%f"
			printf "Would poweroff here.\n"
			# /usr/bin/poweroff
		fi
		print -P "\n%fCancelling."
		return
	fi
	printf "Would poweroff here.\n"
	# /usr/bin/poweroff
}
