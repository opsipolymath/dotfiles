# {XDG_CONFIG_HOME}/shell-modules/20-yubikey.sh
#
# Settings related to yubikeys

# Set active yubikey to one currently connected
gpg-connect-agent "scd serialno" "learn --force" /bye &>/dev/null

# Create alias for same
alias yku="/usr/bin/gpg-connect-agent 'scd serialno' 'learn --force' /bye &>/dev/null"
