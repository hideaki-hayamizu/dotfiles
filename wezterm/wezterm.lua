local wezterm = require('wezterm')
local utils = require('utils')

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

--  load configuration files
for _, v in ipairs(wezterm.glob(wezterm.config_dir .. '/config/*.lua')) do
  local mod = 'config.' .. utils.format.get_file_name(v)
  local ok, re = pcall(require, mod)
  if ok then
    utils.tbl.merge_tables(config, re)
  else
    wezterm.log_error('ERR: Failed to load ' .. mod)
  end
end

return config