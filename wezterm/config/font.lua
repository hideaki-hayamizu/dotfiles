local wezterm = require('wezterm')
local utils = require('utils')

local default_fonts = {
  user = { 'Firge35Nerd Console' },
  wez = { 'JetBrains Mono', 'Noto Color Emoji', 'Symbols Nerd Font Mono' },
  windows = { 'Consolas' },
  macos = { 'San Francisco' },
  linux = { 'DejaVu Sans' },
  wsl = { 'DejaVu Sans' }
}

local function detect_fonts()
  local fonts = {}

  for _, font in ipairs(default_fonts.user) do
    table.insert(fonts, font)
  end

  local platform_fonts =
  utils.platform.is_wsl and default_fonts.wsl or
  utils.platform.is_windows and default_fonts.windows or
  utils.platform.is_macos and default_fonts.macos or
  utils.platform.is_linux and default_fonts.linux or {}

  for _, font in ipairs(platform_fonts) do
    table.insert(fonts, font)
  end

  for _, font in ipairs(default_fonts.wez) do
    table.insert(fonts, font)
  end

  return fonts
end

local font_size_file = wezterm.config_dir .. '/font_size'

local font_size = function()
  local default = 11.5

  local f = io.open(font_size_file, 'r')
  if not f then
    return default
  end

  local line = f:read('*l')
  f:close()

  local size = tonumber(line)
  if not size then
    return default
  end

  return size
end

local config = {}

config.font_size = font_size()
config.command_palette_font_size = font_size()
config.font = wezterm.font_with_fallback(detect_fonts())

return config