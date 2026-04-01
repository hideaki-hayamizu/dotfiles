local wezterm = require('wezterm')
local colors = require('colors')
local utils = require('utils')

local triangle_left = wezterm.nerdfonts.ple_lower_right_triangle
local triangle_right = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local bg = colors.get_palette(colors.get_appearance()).bg
  local fg = colors.get_palette(colors.get_appearance()).fg
  local edge_bg = 'none'
  if tab.is_active then
    bg = colors.invert_color(bg)
    fg = colors.invert_color(fg)
  end
  local edge_fg = bg

  return {
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = triangle_left },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = utils.format.base_name(tab.active_pane.title) },
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = triangle_right },
  }
end)

local config = {}

config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.window_frame = {
  inactive_titlebar_bg = 'none',
  active_titlebar_bg = 'none',
}
config.window_background_gradient = {
  colors = { colors.get_palette(colors.get_appearance()).bg }
}
config.colors = {
  tab_bar = { inactive_tab_edge = 'none' },
}

return config