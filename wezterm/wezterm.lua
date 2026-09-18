local wezterm = require("wezterm")
local utils = require("utils")

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
  config:set_strict_mode(true)
end

-- load config files
local config_files_regex = wezterm.config_dir .. "/config/*.lua"

for _, v in ipairs(wezterm.glob(config_files_regex)) do
  config = utils.merge_tables(config, require("config." .. utils.basename(v)))
end

-- maximize window on startup
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config