# OMARCHY 64 easter egg (toggle with: c64)
if [[ -n "${OMARCHY_C64:-}" && -r "$HOME/.config/omarchy/c64/splash.sh" ]]; then
  source "$HOME/.config/omarchy/c64/splash.sh"
fi
