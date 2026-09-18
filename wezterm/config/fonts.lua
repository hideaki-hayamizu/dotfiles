local wezterm = require("wezterm")
local utils = require("utils")

local config = {}

local custom_fonts = wezterm.font_with_fallback({
  -- user
  "Moralerspace Radon HWJPDOC",
  -- builtin
  "JetBrains Mono",
  "Nerd Font Symbols",
  "Noto Color Emoji",
})

config.font = custom_fonts
config.char_select_font = custom_fonts
config.command_palette_font = custom_fonts
config.pane_select_font = custom_fonts

local lines = utils.read_file(wezterm.config_dir .. "/font-size")
local user_font_size = tonumber((lines and lines[1]) or "12.0")

config.font_size = user_font_size
config.char_select_font_size = user_font_size
config.command_palette_font_size = user_font_size

config.window_frame = {
  font = custom_fonts,
  font_size = 9,
}

return config