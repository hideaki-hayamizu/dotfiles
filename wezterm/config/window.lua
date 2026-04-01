local wezterm = require('wezterm')
local colors = require('colors')

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on('update-status', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.color_scheme = colors.get_color_scheme(colors.get_appearance()) or nil
  overrides.command_palette_bg_color = colors.get_palette(colors.get_appearance()).bg
  overrides.command_palette_fg_color = colors.get_palette(colors.get_appearance()).fg
  window:set_config_overrides(overrides)
end)

local config = {}

config.color_scheme = colors.get_color_scheme(colors.get_appearance())
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_background_opacity = 0.9
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_content_alignment = {
  horizontal = 'Center',
  vertical = 'Center',
}
config.command_palette_bg_color = colors.get_palette(colors.get_appearance()).bg
config.command_palette_fg_color = colors.get_palette(colors.get_appearance()).fg

return config