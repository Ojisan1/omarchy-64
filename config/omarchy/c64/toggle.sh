#!/bin/bash
# Toggle the OMARCHY 64 Super+Enter easter egg.
# Usage: c64 [on|off|toggle|status]

set -euo pipefail

flag="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/c64-terminal"
mkdir -p "$(dirname "$flag")"

usage() {
  echo "Usage: c64 [on|off|toggle|status]" >&2
}

cmd="${1:-toggle}"
enabled=0

case "$cmd" in
-h | --help)
  usage
  exit 0
  ;;
on | enable)
  touch "$flag"
  enabled=1
  ;;
off | disable)
  rm -f "$flag"
  enabled=0
  ;;
toggle)
  if [[ -f "$flag" ]]; then
    rm -f "$flag"
    enabled=0
  else
    touch "$flag"
    enabled=1
  fi
  ;;
status)
  if [[ -f "$flag" ]]; then
    echo "on"
  else
    echo "off"
  fi
  exit 0
  ;;
*)
  usage
  exit 1
  ;;
esac

notify() {
  omarchy-notification-send -u low "$@" >/dev/null 2>&1 || true
}

if ((enabled)); then
  notify "OMARCHY 64" "Super+Enter loads the blue screen. Type c64 to leave."
  if [[ -z "${OMARCHY_C64:-}" ]]; then
    printf '\nOMARCHY 64 enabled. Super+Enter opens the blue screen.\nType c64 to switch back.\n'
    "$HOME/.config/omarchy/c64/launch.sh" >/dev/null 2>&1 &
    disown || true
  else
    printf '\nOMARCHY 64 IS ON\nSUPER+ENTER FOR A NEW WINDOW\n\nREADY.\n'
  fi
else
  notify "OMARCHY 64" "Back to the default terminal."
  printf '\nOMARCHY 64 off. Next Super+Enter is the normal terminal.\n'
fi
