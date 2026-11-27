local M = {}
local utils = require("utils")

local function set_shell()
  if utils.is_windows then
    return { "pwsh.exe", "-NoLogo" }
  elseif utils.is_macos then
    return { "zsh" }
  else
    return { "bash" }
  end
end

M.default_prog = set_shell()
M.automatically_reload_config = false
M.bypass_mouse_reporting_modifiers = "SHIFT"
M.enable_kitty_keyboard = false
M.exit_behavior = "CloseOnCleanExit"
M.front_end = "WebGpu"
M.macos_forward_to_ime_modifier_mask = "SHIFT"
M.macos_fullscreen_extend_behind_notch = false
M.native_macos_fullscreen_mode = false
M.pane_focus_follows_mouse = false
M.scrollback_lines = 1000
M.use_ime = true
M.warn_about_missing_glyphs = false
M.window_close_confirmation = "NeverPrompt"

M.adjust_window_size_when_changing_font_size = false
M.animation_fps = 60
M.audible_bell = "Disabled"
M.cursor_blink_rate = 800
M.mouse_wheel_scrolls_tabs = false
M.status_update_interval = 1000

return M