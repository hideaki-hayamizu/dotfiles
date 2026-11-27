local M = {}
local wezterm = require("wezterm")
local utils = require("utils")

local theme_ls = {
  gruvbox = {
    dark = {
      color_scheme = "Gruvbox Dark (Gogh)",
      bg = "#282828",
      fg = "#EBDBB2",
    },
    light = {
      color_scheme = "Gruvbox (Gogh)",
      bg = "#FBF1C7",
      fg = "#3C3836",
    },
  },
}

local default_theme = "gruvbox"

M.get_palette = function ()
  local path = wezterm.config_dir .. "/conf.txt"

  utils.ensure_line(path, 1, default_theme)

  local theme
  local lines = utils.read_lines(path)
  if lines and lines[1] then
    theme = lines[1]:gsub("^%s+", ""):gsub("%s+$", ""):lower()
  end

  if not theme or theme == "" or not theme_ls[theme] then
    theme = default_theme
  end

  local appearance = wezterm.gui.get_appearance()
  appearance = appearance:find("Dark") and "dark" or "light"

  return theme_ls[theme][appearance]
end

M.dim = function (hex)
  hex = hex:gsub("#", "")
  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)
  local f = 0.7
  return string.format(
    "#%02x%02x%02x",
    math.floor(r * f + 0.5),
    math.floor(g * f + 0.5),
    math.floor(b * f + 0.5)
  )
end

return M