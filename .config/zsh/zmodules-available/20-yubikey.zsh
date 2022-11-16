#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/20-yubikey.zsh
#
# Settings related to yubikeys

# Set active yubikey to one currently connected
gpg-connect-agent "scd serialno" "learn --force" /bye &>/dev/null

# Create alias for same
alias yku="/usr/bin/gpg-connect-agent 'scd serialno' 'learn --force' /bye &>/dev/null"
