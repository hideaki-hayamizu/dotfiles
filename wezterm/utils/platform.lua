local wezterm = require('wezterm')

local target = wezterm.target_triple

local M = {}

M.is_wsl = wezterm.running_under_wsl()
M.is_windows = target:find('windows') ~= nil
M.is_macos = target:find('darwin') ~= nil
M.is_linux = target:find('linux') ~= nil and not M.is_wsl

function M.detect_desktop_environment()
  local desktop_environment = os.getenv('DESKTOP_SESSION') or os.getenv('XDG_CURRENT_DESKTOP')
  if not desktop_environment then
    return
  end

  return desktop_environment:lower()
end

return M