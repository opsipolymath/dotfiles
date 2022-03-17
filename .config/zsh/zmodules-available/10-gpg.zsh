#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/10-gpg.sh
#
# Configure GPG towork as SSH agent and cache passwords

# Export necessary varaibles
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GPG_TTY=$(tty)

# Restart the agent to reload configuration
gpg-connect-agent /bye &>/dev/null
