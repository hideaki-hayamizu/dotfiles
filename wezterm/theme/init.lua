local wezterm = require("wezterm")

local M = {}

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Light"
end

function M.get_palette()
  local is_dark_mode = string.find(get_appearance(), "Dark") ~= nil
  local mode = is_dark_mode and "dark" or "light"
  local mod = require("theme." .. mode)

  return mod
end

function M.get_bg_image()
  local is_dark_mode = string.find(get_appearance(), "Dark") ~= nil
  local mode = is_dark_mode and "dark" or "light"

  return wezterm.config_dir .. "/images/" .. mode .. ".jpg"
end

return M