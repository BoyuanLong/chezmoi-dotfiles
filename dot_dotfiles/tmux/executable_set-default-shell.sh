#!/bin/sh
set -eu

# Query the account database because SHELL can reflect the launching process.
if [ "$(uname -s)" = Darwin ]; then
    login_shell=$(dscl /Search -read "/Users/$(id -un)" UserShell | awk '/^UserShell:/ { print $2 }')
else
    login_shell=$(getent passwd "$(id -u)" | cut -d: -f7)
fi

case "$login_shell" in
    /*) [ -x "$login_shell" ] || exit 1 ;;
    *) printf '%s\n' 'Could not find an executable account login shell.' >&2; exit 1 ;;
esac

tmux set-option -g default-shell "$login_shell"
tmux set-option -g default-command ''
tmux set-environment -g SHELL "$login_shell"
