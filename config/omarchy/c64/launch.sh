#!/bin/bash
# Super+Enter launcher: C64 foot profile when enabled, otherwise the default terminal.

flag="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/c64-terminal"

if [[ -f "$flag" ]]; then
  # Always boot at $HOME — a C64 does not inherit the directory you typed LOAD in.
  exec setsid uwsm-app -- foot --app-id=org.omarchy.c64 \
    -c "$HOME/.config/foot/c64.ini" \
    -D "$HOME" \
    "$@"
fi

exec omarchy-launch-terminal "$@"
