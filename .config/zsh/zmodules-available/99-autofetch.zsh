#!/bin/zsh

# ${ZDOTDIR}/zmodules-available/99-autofetch.zsh
#
# Automatically fetch dotfiles in the background to be ready to pull

# NOTE: This *will* pop-up the pinentry to unlock a card or key if a non-empty
# passphrase or security token/card is being used for git authentication.

if type dotfiles &>/dev/null; then
	dotfiles fetch &>/dev/null &!
fi
