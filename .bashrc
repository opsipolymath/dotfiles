# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Run actual bashrc, if it exists
if [[ -f "$XDG_CONFIG_HOME"/bash/bashrc ]]; then
	. "${XDG_CONFIG_HOME}"/bash/bashrc
	return
fi

# Do basic setup if no actual bashrc exists
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
