#!/bin/bash
# Open one OMARCHY 64 foot window. Always boots at $HOME.

exec setsid uwsm-app -- foot --app-id=org.omarchy.c64 \
  -c "$HOME/.config/foot/c64.ini" \
  -D "$HOME" \
  "$@"
