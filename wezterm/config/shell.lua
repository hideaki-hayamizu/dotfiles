local utils = require('utils')

local function detect_shell()
  if  utils.platform.is_linux or utils.platform.is_wsl then
    return { 'bash' }
  elseif utils.platform.is_windows then
    return { 'pwsh.exe' } -- { 'powershell.exe' }
  elseif utils.platform.is_macos then
    return { 'zsh' }
  end
end

local config = {}

config.default_prog = detect_shell()

return config