# shellcheck shell=bash
# Entry point for interactive Bash configuration.
export SHELL_HOME="${BDOTDIR}/.."
# zsh reads shellenv through .zshenv; Bash has no equivalent, so load it here.
# shellcheck source=../shellenv
source "${SHELL_HOME}/shellenv"
# shellcheck source=../shellrc
source "${SHELL_HOME}/shellrc"
