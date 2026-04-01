local wezterm = require('wezterm')
local utils = require('utils')

local desktop_environment = utils.platform.detect_desktop_environment()

local theme_file = wezterm.config_dir .. '/theme'

local M = {}

local function query_appearance_gnome()
  local success, stdout = wezterm.run_child_process {
    'gsettings',
    'get',
    'org.gnome.desktop.interface',
    'gtk-theme',
  }
  -- lowercase and remove whitespace
  stdout = stdout:lower():gsub('%s+', '')
  local mapping = {
    highcontrast = 'light',
    highcontrastinverse = 'dark',
    adwaita = 'light',
    ['adwaita-dark'] = 'dark',
  }
  local appearance = mapping[stdout]
  if appearance then
    return appearance
  end
  if stdout:find('dark') then
    return 'dark'
  end
  return 'light'
end

function M.invert_color(color)
  local hex = color:gsub('#', '')

  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)

  r = 255 - r
  g = 255 - g
  b = 255 - b

  return string.format('#%02X%02X%02X', r, g, b)
end

function M.get_appearance()
  if desktop_environment and desktop_environment:find('gnome') then
    local appearance = query_appearance_gnome()
    return appearance
  end
  if wezterm.gui then
    local appearance = wezterm.gui.get_appearance()
    return appearance:find('Dark') and 'dark' or 'light'
  end
  return 'light'
end

function M.get_color_scheme(appearance)
  local default = require('colors.default')

  local f = io.open(theme_file, 'r')
  if not f then
    return default.color_scheme[appearance]
  end

  local theme = f:read('*l')
  f:close()
  if not theme or theme == '' then
    return default.color_scheme[appearance]
  end

  local ok, re = pcall(require, 'colors.' .. theme)
  if not ok then
    return default.color_scheme[appearance]
  end
  return re.color_scheme[appearance]
end

function M.get_palette(appearance)
  local default = require('colors.default')

  local f = io.open(theme_file, 'r')
  if not f then
    return {
      bg = default.bg[appearance],
      fg = default.fg[appearance],
    }
  end

  local theme = f:read('*l')
  f:close()
  if not theme or theme == '' then
    return {
      bg = default.bg[appearance],
      fg = default.fg[appearance],
    }
  end

  local ok, re = pcall(require, 'colors.' .. theme)
  if not ok then
    return {
      bg = default.bg[appearance],
      fg = default.fg[appearance],
    }
  end
  return {
    bg = re.bg[appearance],
    fg = re.fg[appearance],
  }
end

function M.save_color_scheme(text)
  local file = io.open(theme_file, 'w')
	if file then
    file:write(tostring(text))
    file:close()
  end
end

return M