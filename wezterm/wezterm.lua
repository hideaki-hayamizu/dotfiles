local wezterm = require("wezterm")
local utils = require("utils")

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
  config:set_strict_mode(true)
end

for _, p in ipairs(wezterm.glob(wezterm.config_dir .. "/config/*.lua")) do
  local v = require("config." .. p:match("([^/\\]+)%.lua$"))
  utils.merge_tables(config, v)
end

return config