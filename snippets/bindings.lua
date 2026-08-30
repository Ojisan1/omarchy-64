-- Super+Enter launches the C64 profile when enabled via `c64`.
-- Off is a passthrough to the default terminal.
hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Terminal", os.getenv("HOME") .. "/.config/omarchy/c64/launch.sh")
