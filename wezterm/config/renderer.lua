local wezterm = require("wezterm")
local utils = require("utils")
local theme = require("theme")

local config = {}

local palette = theme.get_palette()
local bg = palette.bg
local fg = palette.fg
local colorscheme = palette.colorscheme
local bg_image = theme.get_bg_image()

local decorations = {
  triangle = {
    left = "",
    right = "",
  },
  half_circle = {
    left = "",
    right = "",
  },
}
local icons = {
  zoom = "",
  ime = "󰫷",
  leader_key = "󰫹",
  clock = "",
  battery = "",
}

local hide_bg_image = false

local window_opacity = hide_bg_image and 0 or 0.9

config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

-- window
config.color_scheme = colorscheme
config.window_background_opacity = window_opacity
config.win32_system_backdrop = hide_bg_image and "Acrylic" or "Disable"
config.macos_window_background_blur = hide_bg_image and 20 or 0
config.wayland_window_background_blur = hide_bg_image
if not hide_bg_image then
  config.background = {
    {
      source = { File = bg_image },
      repeat_x = "NoRepeat",
      repeat_y = "NoRepeat",
      vertical_align = "Middle",
      horizontal_align = "Center",
      opacity = window_opacity,
    }
  }
end
config.char_select_bg_color = utils.invert_hex_color(bg)
config.char_select_fg_color = utils.invert_hex_color(fg)
config.command_palette_bg_color = bg
config.command_palette_fg_color = fg
config.window_frame = {
  active_titlebar_bg = "none",
  inactive_titlebar_bg = "none",
}
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 150,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 150,
}
config.enable_scroll_bar = false
config.integrated_title_button_color = fg
config.integrated_title_button_style = "Gnome"
config.integrated_title_buttons = { "Hide", "Maximize", "Close" }
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.native_macos_fullscreen_mode = false
config.macos_fullscreen_extend_behind_notch = true
config.window_content_alignment = {
  horizontal = "Center",
  vertical = "Center",
}
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

wezterm.on("format-window-title", function(tab)
  return utils.basename(tab.active_pane.foreground_process_name)
end)

-- pane
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}

-- tab
config.enable_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.show_tabs_in_tab_bar = false
config.use_fancy_tab_bar = true
config.show_close_tab_button_in_tabs = false
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.window_background_gradient = {
  colors = { bg },
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local bg = tab.is_active and utils.invert_hex_color(bg) or bg
  local fg = tab.is_active and utils.invert_hex_color(fg) or fg
  local edge_bg = "none"
  local edge_fg = bg

  local title = wezterm.truncate_right(utils.basename(tab.active_pane.title), max_width - 1)

  return {
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = decorations.triangle.left },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = title },
    { Background = { Color = edge_bg } },
    { Foreground = { Color = edge_fg } },
    { Text = decorations.triangle.right },
  }
end)

-- status
local function add_component(components, bg, fg, icon, text)
  table.insert(components, { Background = { Color = bg } })
  table.insert(components, { Foreground = { Color = fg } })

  local tmp = {}
  if icon then
    table.insert(tmp, icon .. " ")
  end
  if text then
    table.insert(tmp, text)
  end

  table.insert(components, { Text = table.concat(tmp) })
end

wezterm.on("update-status", function(window, pane)
  local left_components = {}
  local right_components = {}

  local edge_bg = "none"
  local edge_fg = bg

  -- decorations
  add_component(left_components, edge_bg, edge_fg, nil, decorations.half_circle.left)
  add_component(right_components, edge_bg, edge_fg, nil, decorations.half_circle.left)

  -- ime
  add_component(left_components, bg, fg, window:composition_status() and icons.ime or " ", nil)

  -- leader_key
  add_component(left_components, bg, fg, window:leader_is_active() and icons.leader_key or " ", nil)

  -- zoomed_tab
  local is_zoomed = false
  for _, tab in ipairs(window:mux_window():tabs_with_info()) do
    if tab.is_active then
      for _, pane in ipairs(tab.tab:panes_with_info()) do
        if pane.is_active then
          is_zoomed = pane.is_zoomed
        end
      end
    end
  end
  add_component(left_components, bg, fg, is_zoomed and icons.zoom or " ", nil)

  -- key tables
  local key_table = window:active_key_table() or "?"
  add_component(right_components, bg, fg, nil, " " .. key_table .. " ")

  -- process name
  if not config.show_tabs_in_tab_bar then
    local proc_name = utils.basename(pane:get_foreground_process_name() or "?")
    add_component(right_components, bg, fg, nil, proc_name .. " ")
  end

  -- tab index
  local current_index
  for _, tab in ipairs(window:mux_window():tabs_with_info()) do
    if tab.is_active then
      current_index = tab.index + 1
    end
  end

  local tabs_count = "/" .. tostring(#window:mux_window():tabs())
  add_component(right_components, bg, fg, nil, "(" .. current_index .. tabs_count .. ") ")

  -- time
  add_component(right_components, bg, fg, icons.clock, wezterm.strftime("%a %b %-d %H:%M "))

  -- battery
  for _, b in ipairs(wezterm.battery_info()) do
    add_component(right_components, bg, fg, icons.battery, string.format("%.0f%%", b.state_of_charge * 100))
  end

  -- decorations
  add_component(left_components, edge_bg, edge_fg, nil, decorations.half_circle.right)
  add_component(right_components, edge_bg, edge_fg, nil, decorations.half_circle.right)

  window:set_left_status(wezterm.format(left_components))
  window:set_right_status(wezterm.format(right_components))
end)

return config