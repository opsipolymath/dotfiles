# ~/.bash_profile

# Load environment variables if they exist
if [[ -f "${HOME}/.config/environment.d/00-bash.conf" ]]; then
	. "${HOME}/.config/environment.d/00-bash.conf"

# Load bashrc if it exists
[[ -f ~/.bashrc ]] && . ~/.bashrc
