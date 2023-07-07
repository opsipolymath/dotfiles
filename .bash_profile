# ~/.bash_profile

# Load environment variables if they exist
if [[ -f "${HOME}/.config/environment.d/00-bash.conf" ]]; then
	set -a
	. "${HOME}/.config/environment.d/00-bash.conf"
	set +a
fi

# Load bashrc if it exists
[[ -f ~/.bashrc ]] && . ~/.bashrc
