local M = {}
local wezterm = require("wezterm")
local dim = require("colors").dim
local palette = require("colors").get_palette()
local utils = require("utils")

local icons = {
  left_decoration = " ",
  right_decoration = " ",
  leader = "L",
  ime = "I",
  zoomed = " ",
  clock = " ",
  bat = " 󰁹",
}

-- colors
M.colors = {
  tab_bar = {
    inactive_tab_edge = "none"
  },
  scrollbar_thumb = dim(palette.bg),
  visual_bell = dim(palette.bg),
}

-- window
M.color_scheme = palette.color_scheme

M.char_select_bg_color = dim(palette.bg)
M.char_select_fg_color = dim(palette.fg)

M.command_palette_bg_color = palette.bg
M.command_palette_fg_color = palette.fg

M.cursor_blink_ease_in = "EaseIn"
M.cursor_blink_ease_out =  "EaseInOut"
M.cursor_thickness = 0
M.default_cursor_style = "SteadyBlock" -- "BlinkingBar" 

M.enable_scroll_bar = false

M.foreground_text_hsb = {
  hue = 1.0,
  saturation = 1.0,
  brightness = 0.8,
}

M.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}

if utils.is_windows then
  M.window_background_opacity = 0.7
  M.win32_system_backdrop = "Acrylic"
elseif utils.is_macos then
  M.window_background_opacity = 0.8
  M.macos_window_background_blur = 20
elseif utils.is_linux then
  M.window_background_opacity = 0.8
  M.wayland_window_background_blur = true
end

M.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 150,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 150,
}

M.window_background_gradient = {
  colors = { palette.bg }
}

M.window_content_alignment = {
  horizontal = "Center",
  vertical = "Center",
}

M.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

M.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

-- title bar
M.integrated_title_button_color = palette.fg
M.integrated_title_button_style = "Gnome"
M.integrated_title_buttons = { "Hide", "Maximize", "Close" }

wezterm.on("format-window-title", function (tab)
  return utils.basename(tab.active_pane.foreground_process_name)
end)

-- tabs
M.enable_tab_bar = true
M.hide_tab_bar_if_only_one_tab = false
M.show_close_tab_button_in_tabs = false
M.show_new_tab_button_in_tab_bar = false
M.show_tab_index_in_tab_bar = false
M.show_tabs_in_tab_bar = false
M.tab_bar_at_bottom = false
M.tab_max_width = 16
M.use_fancy_tab_bar = true

wezterm.on("format-tab-title", function (tab, tabs, panes, config, hover, max_width)
  local bg = dim(palette.bg)
  local fg = dim(palette.fg)
  if tab.is_active then
    bg = palette.bg
    fg = palette.fg
  end
  local edge_fg = bg
  local edge_bg = "none"
  local title = wezterm.truncate_right(utils.basename(tab.active_pane.title), max_width)

  return {
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = icons.left_decoration },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = title },
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = icons.right_decoration },
  }
end)

-- status
local function is_zoomed(window)
  for _, p in ipairs(window:mux_window():active_tab():panes_with_info()) do
    if p.is_active then
      return p.is_zoomed
    end
  end
  return false
end

local function key_table_name(window)
  local name_width = 16
  if not window then
    return ""
  end

  local ok, table_name = pcall(function()
    return window:active_key_table()
  end)
  if not ok or not table_name or table_name == "" then
    return ""
  end

  local name = table_name
  if wezterm.column_width(name) > name_width then
    return wezterm.truncate_right(name, name_width - 3) .. "..."
  end
  local pad = name_width - wezterm.column_width(name)
  local left = math.floor(pad / 2)
  local right = pad - left
  return string.rep(" ", left) .. name .. string.rep(" ", right)
end

local function process_name(pane)
  local name_width = 16
  if not pane then
    return ""
  end
  local ok, path = pcall(function()
    return pane:get_foreground_process_name()
  end)
  if not ok or not path or path == "" then
    return ""
  end

  local name = utils.basename(path)
  if wezterm.column_width(name) > name_width then
    return wezterm.truncate_right(name, name_width - 3) .. "..."
  end
  local pad = name_width - wezterm.column_width(name)
  local left = math.floor(pad / 2)
  local right = pad - left
  return string.rep(" ", left) .. name .. string.rep(" ", right)
end

local function tab_position(window)
  local tabs = window:mux_window():tabs_with_info()
  for _, t in ipairs(tabs) do
    if t.is_active then
      return string.format("|%d/%d|", t.index + 1, #tabs)
    end
  end
  return ""
end

wezterm.on("update-status", function (window, pane)
  local bg = palette.bg
  local fg = palette.fg
  local edge_fg = bg
  local edge_bg = "none"
  local left = {}
  local right = {}

  table.insert(left, { Background = { Color = edge_bg } })
  table.insert(left, { Foreground = { Color = edge_fg } })
  table.insert(left, { Text = icons.left_decoration })
  table.insert(right, { Background = { Color = edge_bg } })
  table.insert(right, { Foreground = { Color = edge_fg } })
  table.insert(right, { Text = icons.left_decoration })

  table.insert(left, { Background = { Color = bg } })
  table.insert(left, { Foreground = { Color = fg } })
  table.insert(left, { Text = window:composition_status() and icons.ime or " " })

  table.insert(left, { Background = { Color = bg } })
  table.insert(left, { Foreground = { Color = fg } })
  table.insert(left, { Text = window:leader_is_active() and icons.leader or " " })

  table.insert(left, { Background = { Color = bg } })
  table.insert(left, { Foreground = { Color = fg } })
  table.insert(left, { Text = is_zoomed(window) and icons.zoomed or " " })

  local tbl = key_table_name(window)
  if tbl ~= "" then
    table.insert(left, { Background = { Color = bg } })
    table.insert(left, { Foreground = { Color = fg } })
    table.insert(left, { Text = " " .. tbl })
  else
    table.insert(left, { Background = { Color = bg } })
    table.insert(left, { Foreground = { Color = fg } })
    table.insert(left, { Text = "                 " })
  end

  local proc = process_name(pane)
  if proc ~= "" then
    table.insert(right, { Background = { Color = bg } })
    table.insert(right, { Foreground = { Color = fg } })
    table.insert(right, { Text = proc .. " " })
  else
    table.insert(right, { Background = { Color = bg } })
    table.insert(right, { Foreground = { Color = fg } })
    table.insert(right, { Text = "                 " })
  end

  local pos = tab_position(window)
  if pos ~= "" then
    table.insert(right, { Background = { Color = bg } })
    table.insert(right, { Foreground = { Color = fg } })
    table.insert(right, { Text = pos .. " " })
  end

  table.insert(right, { Background = { Color = bg } })
  table.insert(right, { Foreground = { Color = fg } })
  table.insert(right, { Text = icons.clock .. wezterm.strftime("%a %b %-d %H:%M") })

  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(right, { Background = { Color = bg } })
    table.insert(right, { Foreground = { Color = fg } })
    table.insert(right, { Text = icons.bat .. string.format("%.0f%%", b.state_of_charge * 100) })
  end

  table.insert(left, { Background = { Color = edge_bg } })
  table.insert(left, { Foreground = { Color = edge_fg } })
  table.insert(left, { Text = icons.right_decoration })
  table.insert(right, { Background = { Color = edge_bg } })
  table.insert(right, { Foreground = { Color = edge_fg } })
  table.insert(right, { Text = icons.right_decoration })

  window:set_left_status(wezterm.format(left))
  window:set_right_status(wezterm.format(right))
end)

return M