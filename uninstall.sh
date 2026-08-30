#!/bin/bash
# OMARCHY 64 — user-space uninstall. No sudo.
set -euo pipefail

MARKER="OMARCHY 64"
FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/c64"
FLAG="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/c64-terminal"

remove_block() {
  local file="$1" comment="$2"
  local start="${comment} >>> ${MARKER} >>>"
  local end="${comment} <<< ${MARKER} <<<"
  [[ -f "$file" ]] || return 0
  local tmp
  tmp="$(mktemp)"
  awk -v s="$start" -v e="$end" '
    $0 == s { skip = 1; next }
    $0 == e { skip = 0; next }
    !skip { print }
  ' "$file" >"$tmp"
  mv "$tmp" "$file"
}

echo "**** OMARCHY 64 UNINSTALL ****"
echo

rm -f "$FLAG"
rm -f "$HOME/.local/bin/c64"
rm -rf "$HOME/.config/omarchy/c64"
rm -f "$HOME/.config/foot/c64.ini"
rm -rf "$FONT_DIR"
fc-cache -f >/dev/null 2>&1 || true

remove_block "$HOME/.bashrc" "#"
remove_block "$HOME/.config/hypr/bindings.lua" "--"
remove_block "$HOME/.config/hypr/hyprland.lua" "--"

if command -v hyprctl >/dev/null && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  hyprctl reload >/dev/null
fi

echo "Removed. No leftover binds or terminal profiles."
echo
echo "READY."
