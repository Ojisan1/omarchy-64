#!/bin/bash
# OMARCHY 64 — user-space install. No sudo.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
MARKER="OMARCHY 64"
FONT_ZIP_URL="https://style64.org/file/C64_TrueType_v1.2.1-STYLE.zip"
FONT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/c64"

die() { echo "OMARCHY 64: $*" >&2; exit 1; }

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

upsert_block() {
  local file="$1" comment="$2" snippet="$3"
  local start="${comment} >>> ${MARKER} >>>"
  local end="${comment} <<< ${MARKER} <<<"
  mkdir -p "$(dirname "$file")"
  [[ -f "$file" ]] || touch "$file"

  local tmp
  tmp="$(mktemp)"
  awk -v s="$start" -v e="$end" '
    $0 == s { skip = 1; next }
    $0 == e { skip = 0; next }
    !skip { print }
  ' "$file" >"$tmp"

  {
    cat "$tmp"
    printf '\n%s\n' "$start"
    cat "$snippet"
    printf '%s\n' "$end"
  } >"$file"
  rm -f "$tmp"
}

echo "**** OMARCHY 64 INSTALL ****"
echo

command -v foot >/dev/null || die "foot is not on PATH (Omarchy's default terminal)"
command -v curl >/dev/null || die "curl is required to fetch C64 Pro Mono"
command -v unzip >/dev/null || die "unzip is required to unpack C64 Pro Mono"

# --- configs ---
mkdir -p "$HOME/.config/omarchy/c64" "$HOME/.config/foot" "$HOME/.local/bin"
cp "$ROOT/config/omarchy/c64/launch.sh" "$HOME/.config/omarchy/c64/"
cp "$ROOT/config/omarchy/c64/toggle.sh" "$HOME/.config/omarchy/c64/"
cp "$ROOT/config/omarchy/c64/splash.sh" "$HOME/.config/omarchy/c64/"
cp "$ROOT/config/foot/c64.ini" "$HOME/.config/foot/c64.ini"
chmod +x "$HOME/.config/omarchy/c64/launch.sh" "$HOME/.config/omarchy/c64/toggle.sh"
ln -sfn "$HOME/.config/omarchy/c64/toggle.sh" "$HOME/.local/bin/c64"

# --- font (official Style package, not hosted in this repo) ---
mkdir -p "$FONT_DIR"
if [[ ! -f "$FONT_DIR/C64_Pro_Mono-STYLE.ttf" ]]; then
  echo "Fetching C64 Pro Mono from style64.org..."
  tmpdir="$(mktemp -d)"
  curl -fsSL "$FONT_ZIP_URL" -o "$tmpdir/c64.zip"
  unzip -q -o "$tmpdir/c64.zip" -d "$tmpdir"
  mono="$(find "$tmpdir" -name 'C64_Pro_Mono-STYLE.ttf' | head -n1)"
  license="$(find "$tmpdir" -name 'license.txt' | head -n1)"
  [[ -n "$mono" ]] || die "zip did not contain C64_Pro_Mono-STYLE.ttf"
  cp "$mono" "$FONT_DIR/C64_Pro_Mono-STYLE.ttf"
  [[ -n "$license" ]] && cp "$license" "$FONT_DIR/license.txt"
  rm -rf "$tmpdir"
  fc-cache -f "$FONT_DIR" >/dev/null 2>&1 || true
else
  echo "C64 Pro Mono already installed."
fi

# --- user config snippets ---
upsert_block "$HOME/.bashrc" "#" "$ROOT/snippets/bashrc.sh"
upsert_block "$HOME/.config/hypr/hyprland.lua" "--" "$ROOT/snippets/hyprland.lua"
# Older installs hijacked Super+Enter. Leave that key alone.
remove_block "$HOME/.config/hypr/bindings.lua" "--"
rm -f "${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/c64-terminal"

if command -v hyprctl >/dev/null && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  hyprctl reload >/dev/null
fi

echo
echo "Installed. Type:  c64"
echo "A CRT floats over the desktop. Super+Enter stays the normal terminal."
echo "exit or Ctrl+D closes it."
echo
echo "READY."
