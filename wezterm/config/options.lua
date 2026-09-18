local utils = require("utils")

local config = {}

config.adjust_window_size_when_changing_font_size = false
config.animation_fps = 60
config.audible_bell = "Disabled"
config.automatically_reload_config = false
config.cursor_blink_rate = 500
config.text_blink_rate = 500
config.enable_kitty_keyboard = true
config.front_end = "WebGpu"
config.mouse_wheel_scrolls_tabs = false
config.scrollback_lines = 10000
config.status_update_interval = 1000
config.use_ime = true
config.warn_about_missing_glyphs = false
config.window_close_confirmation = "NeverPrompt"

-- shell
if utils.is_windows then
  config.default_prog = { "pwsh.exe" }
elseif utils.is_macos then
  config.default_prog = { "zsh" }
else
  config.default_prog = { "bash" }
end

return config