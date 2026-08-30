-- 4:3 CRT dropped onto the desktop. Super+T tiles it.
o.window("^org\\.omarchy\\.c64$", {
  tag = "-default-opacity",
  rounding = 0,
  border_size = 32,
  border_color = "rgb(7869C4) rgb(7869C4)",
  opacity = "1.0 override 1.0 override",
  no_blur = true,
  no_shadow = true,
  float = true,
  center = true,
  size = { "(monitor_h * 0.96)", "(monitor_h * 0.72)" },
})
