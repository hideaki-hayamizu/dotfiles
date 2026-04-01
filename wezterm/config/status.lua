local wezterm = require('wezterm')
local colors = require('colors')
local utils = require('utils')

local triangle_left = wezterm.nerdfonts.ple_lower_right_triangle
local triangle_right = wezterm.nerdfonts.ple_upper_left_triangle
local calendar = wezterm.nerdfonts.md_calendar_blank
local battery = wezterm.nerdfonts.md_battery
local charging_battery = wezterm.nerdfonts.md_battery_charging
local clock = wezterm.nerdfonts.fa_clock_o
local candle = wezterm.nerdfonts.md_candle
local glass = wezterm.nerdfonts.fa_search .. ' '
local penguin = wezterm.nerdfonts.md_penguin

local zen_mode = utils.flag.instance

wezterm.on('update-status', function(window, pane)
  local bg = colors.get_palette(colors.get_appearance()).bg
  local fg = colors.get_palette(colors.get_appearance()).fg
  local edge_bg = 'none'
  local edge_fg = bg

  -- add elements
  local date = wezterm.strftime('%a %b %-d')
  local time = wezterm.strftime('%H:%M')

  local bat = ''
  local state = ''
  for _, b in ipairs(wezterm.battery_info()) do
    bat = string.format('%.0f%%', b.state_of_charge * 100)
    state = b.state -- 'Charging', 'Discharging', 'Empty', 'Full', 'Unknown'
  end

  local tab = pane:tab()
  local is_zoomed = false

  if tab ~= nil then
    for _, pane_attributes in pairs(tab:panes_with_info()) do
      is_zoomed = pane_attributes['is_zoomed'] or is_zoomed
    end
  end

  local mode_ls = {
    window:leader_is_active() and penguin or '  ',
    zen_mode:get('zen_mode' .. window:window_id()) and candle or '  ',
    is_zoomed and glass or '   ',
  }
  local mode = ''
  for _, v in ipairs(mode_ls) do
    mode = mode .. v
  end

  -- left
  window:set_left_status(wezterm.format({
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = triangle_left },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = window:composition_status() and 'J: ' or 'A: ' },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = mode },
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = triangle_right },
  }))
  -- right
  window:set_right_status(wezterm.format({
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = triangle_left },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = calendar .. ' ' .. date .. ' ' },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = clock .. ' ' .. time .. ' ' },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = state == 'Charging' and charging_battery or battery },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = bat },
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = triangle_right },
  }))
end)

local config = {}

config.status_update_interval = 1000

return config