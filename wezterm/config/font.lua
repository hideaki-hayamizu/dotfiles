local M = {}
local wezterm = require("wezterm")
local utils = require("utils")

local fonts = wezterm.font_with_fallback({ "Moralerspace Radon HWJPDOC", "JetBrains Mono", "Noto Color Emoji" })

local default_font_size = 12.0
local path = wezterm.config_dir .. "/conf.txt"

utils.ensure_line(path, 2, tostring(default_font_size))
utils.ensure_line(path, 3, tostring(default_font_size))

local lines = utils.read_lines(path)

local max_font_size = lines and lines[2] and tonumber(lines[2])
if not max_font_size or max_font_size <= 0 then
  max_font_size = default_font_size
end
local full_font_size = lines and lines[3] and tonumber(lines[3])
if not full_font_size or full_font_size <= 0 then
  full_font_size = default_font_size
end

M.char_select_font = fonts
M.command_palette_font = fonts
M.font = fonts
M.pane_select_font = fonts

M.char_select_font_size = default_font_size
M.command_palette_font_size = default_font_size
M.font_size = default_font_size

M.window_frame = {
  font = fonts,
  font_size = 10.0,
}
M.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

wezterm.on("window-resized", function (window, _)
  local dims = window:get_dimensions()
  local overrides = window:get_config_overrides() or {}
  local size

  if dims.is_full_screen then
    size = full_font_size
  elseif utils.is_window_maximized(window) then
    size = max_font_size
  else
    size = nil
  end

  if overrides.font_size == size then
    return
  end

  overrides.char_select_font_size = size
  overrides.command_palette_font_size = size
  overrides.font_size = size
  window:set_config_overrides(overrides)
end)

return M