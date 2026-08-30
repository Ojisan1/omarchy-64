#!/bin/bash
# c64 — pop a floating OMARCHY 64 CRT. Super+Enter is left alone.
# Close the window (exit / Ctrl+D) to dismiss it.

set -euo pipefail

if [[ ! -x "$HOME/.config/omarchy/c64/launch.sh" ]]; then
  echo "OMARCHY 64 is not installed." >&2
  exit 1
fi

"$HOME/.config/omarchy/c64/launch.sh" >/dev/null 2>&1 &
disown
