#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/05-prompt.zsh
#
# Prompt setup

# By default, show git status in prompt
export SHOW_GIT_STATUS="true"

# Load module for adding hooks
autoload -Uz add-zsh-hook

# Use a function so prompt can be re-evaluated more easily
set_prompt () {
	# Define prompt colors
	__norm="%F{blue}"
	__info="%F{green}"
	__error="%F{red}"
	if [ ! -t 1 ] || [ ! -t 2 ]; then
		__norm=""
		__info=""
		__error=""
	fi

	# Change root's displayed name based on host (just for fun)
	__hname="$(hostname)"
	case "${__hname}" in
		folkvangr) __rname="freyja" ;;
		valhalla)  __rname="odin"   ;;
		niflheim)  __rname="hel"    ;;
		midgard)   __rname="thor"   ;;
		*)         __rname="root"   ;;
	esac

	# Start with empty prompts
	unset PROMPT RPROMPT

	# Display PWD in green if writable, red if not
	__pwd="${__error}%~${__norm}"
	if [[ -w "." ]]; then
		__pwd="${__info}%~${__norm}"
	fi

	# By default, use an empty git repo status string
	__git_status=""

	# Determine if git stauts should be displayed and if in a GIT repo
	if [[ "${SHOW_GIT_STATUS}" == "true" ]] &&
			( git status &>/dev/null || [[ "$PWD" == "$HOME" ]] ); then
		# Start to build the status string
		__git_status="${__norm}-["

		# Find out what if we're ahead/behind and update status
		if [[ "$PWD" == "$HOME" ]]; then
			__ahead="$(dots rev-list --count @{u}..HEAD 2>/dev/null)"
			__behind="$(dots rev-list --count HEAD..@{u} 2>/dev/null)"
		else
			__ahead="$(git rev-list --count @{u}..HEAD 2>/dev/null)"
			__behind="$(git rev-list --count HEAD..@{u} 2>/dev/null)"
		fi
		__git_status+="${__info}${__ahead:#0}${__error}${__behind:#0}${__norm}"
		if (( __ahead > 0 )) || (( __behind > 0 )); then
			__git_status+="]-["
		fi

		# Determine if we're clean and update status
		__clean="${__info}clean${__norm}"
		if [[ "$PWD" == "$HOME" ]]; then
			__changes="$(dots status --porcelain=v1 2>/dev/null | wc -l)"
		else
			__changes="$(git status --porcelain=v1 2>/dev/null | wc -l)"
		fi
		if (( __changes > 0 )); then
			__clean="${__error}"$'\e[9m'"clean"$'\e[0m'"${__norm}"
			# Strikethrough doesn't work on console so use an alternative
			if [[ "${TERM}" == "linux" ]]; then
				__clean="${__error}unclean${__norm}"
			fi
		fi
		__git_status+="${__clean}"

		# Unset all unneeded variables
		unset __ahead __behind __clean

		# Finish building the status string
		__git_status+="${__norm}]"
	fi

	# Display root in red, regular user in green
	__user="%(#.${__error}${__rname}.${__info}%n)@${__hname:l}"

	# Define the prompt
	__top="${__norm}┌[${__pwd}${__norm}]${__git_status}"
	__bottom="${__norm}└[${__user}${__norm}] %# "
	PROMPT="${__top}"$'\n'"${__bottom}%f"

	# Setup RPROMPT if in an SSH session
	if [[ -n "$SSH_TTY" ]]; then
		__bifrost='via %F{1}b%F{214}i%F{3}f%F{2}r%F{4}ö%F{6}s%F{5}t'
		RPROMPT="${__norm}[${__info}${__bifrost}${__norm}]%f"
		unset __bifrost
	fi

	# Unset unneeded varaibles
	unset __norm __info __error
	unset __hname __rname __pwd __user __git_status __top __bottom

	# Set cursor to a block in vi mode, underline otherwise
	echo -ne '\e[4 q'
	if [[ "${KEYMAP}" == vicmd ]]; then
		echo -ne '\e[2 q'
	fi
}

# Re-evaluate prompt when mode changes
function zle-line-init zle-keymap-select() {
	set_prompt
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Re-evaluate prompt before each command is run
add-zsh-hook precmd set_prompt

# Define multi-line command prompts to be more clear
export PROMPT2='%F{yellow}»··%_%(4l..··)··%F{blue}> %f'
#export PROMPT2='%F{yellow}»·······%F{blue}> %f'

# Define default selection prompt
export PROMPT3='Make a selection: '

# Define shell tracing prompt to be more useful
export PROMPT4='%1N-%I+ '
