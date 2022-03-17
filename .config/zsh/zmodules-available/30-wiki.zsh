#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/30-wiki.zsh
#
# Aliases and functions related to vimwiki
# Only vw() is made to be used outside vim

# Global variables
export WIKI_DIR="$HOME/lyceum"
export WIKI_VALIDTYPES=( book note )

# Aliases
alias wna="__wiki_newnote author"
alias wnb="__wiki_newnote book"
alias wnn="__wiki_newnote note"

# Load the wiki
function vw() {
	wiki="${1:-2}"
	wikidir="$HOME/lyceum/content"
	if [[ "$wiki" == "1" ]]; then
		wikidir="$HOME/notebook/content"
	fi
	pushd "$wikidir"
	nvim -c "VimwikiIndex $wiki"
	popd
}

# Compute filename
# $1: one of WIKI_VALIDTYPES
# $2: string from which to calculate filename
function __wiki_getfilename() {
	notename="${(L)2}" # Convert to lowercase
	notename="$(basename "$notename")"
	notename="$(tr -dc '[:alnum:][:blank:]-' <<< "${notename}")"
	notename="${notename// /-}"
	notename="$(tr -s '-' <<< "${notename}")"
	while [[ "${notename}" =~ [\ -]$ ]]; do
		notename="${notename:0:-1}"
	done
	if [[ ! "${notename}" =~ .md$ ]]; then
		notename="${notename}.md"
	fi
	filename="content/"
	case "$1" in
		book)
			filename+="library/book-notes/"
			;;
		note)
			filename+="slipbox/notes/"
			;;
	esac
	filename+="${notename}"
	return 0
}

# Create file for new note
# $1: one of WIKI_VALIDTYPES
# $2: filename of new note
function __wiki_newnote() {
	if [[ ! -d "${__wiki_dir}" ]]; then
		printf "ERROR: Wiki directory '%s' doesn't exist.\n" "${__wiki_dir}"
		return 1
	fi
	if (( $# < 2 )); then
		printf "ERROR: Not enough arguments passed - need type and filename.\n"
		return 1
	fi
	note_type="$1" && shift
	if (( $__wiki_validtypes[(Ie)$note_type] < 1 )); then
		printf "ERROR: Note type '%s' is invalid.\n" "${note_type}"
		return 1
	fi
	if ! __wiki_getfilename "${note_type}" "$*"
	pushd "${__wiki_dir}"
	hugo new -k "${note_type}" "${filename}"
	result="$?"
	popd
	return "${result}"
}

# Returns a list of tags from notes
function get_tags() {
	notefiles=( "$HOME"/notebook/content/notes/*.md )
	grep -oh "^tags: .*" ${notefiles[@]} | sed 's/^tags: \[//' | sed 's/\]$//' | sed 's/, /\n/g' | sed 's/"//g' | sort | uniq
}

# Syncs wiki to git
function syncwiki() {
	/usr/bin/ssh \
		-ntqF "$XDG_CONFIG_HOME/ssh/config" "$@" \
		aeryxium.com "sudo -S chown -R $USER:$USER /srv/http/notebook"
	rsync --delete \
		-qe "/usr/bin/ssh -F '$XDG_CONFIG_HOME'/ssh/config" \
		-av "$HOME"/notebook/public/ notebook:/srv/http/notebook
	/usr/bin/ssh \
		-ntqF "$XDG_CONFIG_HOME/ssh/config" "$@" \
		aeryxium.com "sudo -S chown -R http:http /srv/http/notebook"
}
