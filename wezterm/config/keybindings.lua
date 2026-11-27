local M = {}
local wezterm = require("wezterm")
local act = wezterm.action
local utils = require("utils")

wezterm.on("toggle-maximize-window", function(window)
  if not utils.is_window_maximized(window) then
    window:maximize()
  else
    window:restore()
  end
end)

M.disable_default_key_bindings = true
M.disable_default_mouse_bindings = true
M.key_map_preference = "Mapped"

M.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }

M.keys = {
  -- workspace
  {
    key = "d",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Create new workspace:",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace({
              name = line,
            }),
            pane
          )
        end
      end),
    }),
  },
  {
    key = "s",
    mods = "LEADER",
    action = act.ShowLauncherArgs({ flags = "TABS|WORKSPACES", title = "Select tab / workspace" }),
  },
  {
    key = "$",
    mods = "LEADER|SHIFT",
    action = act.PromptInputLine({
      description = "Rename workspace:",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    }),
  },
  -- window
  {
    key = "c",
    mods = "LEADER",
    action = act({ SpawnTab = "CurrentPaneDomain" })
  },
  {
    key = "&",
    mods = "LEADER|SHIFT",
    action = act({ CloseCurrentTab = { confirm = true } })
  },
  {
    key = "n",
    mods = "LEADER",
    action = act.ActivateTabRelative(1)
  },
  {
    key = "p",
    mods = "LEADER",
    action = act.ActivateTabRelative(-1)
  },
  {
    key = "l",
    mods = "LEADER|SHIFT",
    action = act({ MoveTabRelative = 1 })
  },
  {
    key = "h",
    mods = "LEADER|SHIFT",
    action = act({ MoveTabRelative = -1 })
  },
  {
    key = "f",
    mods = "LEADER|SHIFT",
    action = act.ToggleFullScreen
  },
  {
    key = "s",
    mods = "LEADER|SHIFT",
    action = wezterm.action_callback(function(window, pane, line)
      wezterm.emit("toggle-maximize-window", window)
    end)
  },
  -- pane
  {
    key = "\"",
    mods = "LEADER|SHIFT",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" })
  },
  {
    key = "%",
    mods = "LEADER|SHIFT",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" })
  },
  {
    key = "x",
    mods = "LEADER",
    action = act({ CloseCurrentPane = { confirm = true } })
  },
  {
    key = "q",
    mods = "LEADER",
    action = act.PaneSelect
  },
  {
    key = "z",
    mods = "LEADER",
    action = act.TogglePaneZoomState
  },
  -- misc
  {
    key = "p",
    mods = "LEADER|SHIFT",
    action = act.ActivateCommandPalette
  },
  {
    key = "[",
    mods = "LEADER",
    action = act.ActivateCopyMode
  },
  {
    key = "y",
    mods = "LEADER",
    action = act.CopyTo("Clipboard")
  },
  {
    key = "]",
    mods = "LEADER",
    action = act.PasteFrom("Clipboard")
  },
  {
    key = "i",
    mods = "LEADER|SHIFT",
    action = act.IncreaseFontSize
  },
  {
    key = "d",
    mods = "LEADER|SHIFT",
    action = act.DecreaseFontSize
  },
  {
    key = "0",
    mods = "LEADER",
    action = act.ResetFontSize
  },
  {
    key = "r",
    mods = "LEADER|SHIFT",
    action = act.ReloadConfiguration
  },
  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false })
  },
  {
    key = "a",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "activate_pane", timeout_milliseconds = 1000 })
  },
  {
    key = "b",
    mods = "LEADER|CTRL",
    action = act.SendKey({ key = "b", mods = "CTRL" })
  },
  {
    key = "l",
    mods = "CTRL",
    action = act.ClearScrollback("ScrollbackAndViewport")
  },
  {
    key = "w",
    mods = "LEADER|SHIFT",
    action = act.ShowLauncher
  },
  {
    key = "u",
    mods = "LEADER|CTRL",
    action = act.ScrollByPage(-0.5)
  },
  {
    key = "d",
    mods = "LEADER|CTRL",
    action = act.ScrollByPage(0.5)
  },
  {
    key = "l",
    mods = "LEADER",
    action = act.ShowDebugOverlay
  },
}

M.key_tables = {
  resize_pane = {
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "q", action = "PopKeyTable" },
  },
  activate_pane = {
    { key = "h", action = act.ActivatePaneDirection("Left") },
    { key = "j", action = act.ActivatePaneDirection("Down") },
    { key = "k", action = act.ActivatePaneDirection("Up") },
    { key = "l", action = act.ActivatePaneDirection("Right") },
  },
  copy_mode = {
    { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
    { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
    { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
    { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
    { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
    { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
    { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
    { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
    { key = "o", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
    { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
    { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
    { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
    { key = "g", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
    { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
    -- jump
    { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
    { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
    { key = "t", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
    { key = "f", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
    { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
    -- viewport
    { key = "h", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
    { key = "l", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
    { key = "m", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
    -- scroll
    { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
    { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
    { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
    { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
    -- visual mode
    { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
    { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
    { key = "v", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
    -- yank
    { key = "y", mods = "NONE", action = act.CopyTo("Clipboard") },
    -- cancel
    { key = "Escape",  mods = "NONE", action = act.CopyMode("Close") },
    { key = "q",  mods = "NONE", action = act.CopyMode("Close") },
  },
}

M.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.SelectTextAtMouseCursor("Cell"),
  },
  {
    event = { Down = { streak = 2, button = "Left" } },
    mods = "NONE",
    action = act.SelectTextAtMouseCursor("Word"),
  },
  {
    event = { Down = { streak = 3, button = "Left" } },
    mods = "NONE",
    action = act.SelectTextAtMouseCursor("Line"),
  },
  {
    event = { Drag = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.ExtendSelectionToMouseCursor("Cell"),
  },
  {
    event = { Drag = { streak = 2, button = "Left" } },
    mods = "NONE",
    action = act.ExtendSelectionToMouseCursor("Word"),
  },
  {
    event = { Drag = { streak = 3, button = "Left" } },
    mods = "NONE",
    action = act.ExtendSelectionToMouseCursor("Line"),
  },
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "SHIFT",
    action = act.SelectTextAtMouseCursor("Cell"),
  },
  {
    event = { Drag = { streak = 1, button = "Left" } },
    mods = "SHIFT",
    action = act.ExtendSelectionToMouseCursor("Cell"),
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom("Clipboard"),
  },
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = "NONE",
    action = act.ScrollByCurrentEventWheelDelta,
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = "NONE",
    action = act.ScrollByCurrentEventWheelDelta,
  },
}

return M