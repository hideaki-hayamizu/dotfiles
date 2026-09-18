local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

config.key_map_preference = "Mapped"
config.disable_default_key_bindings = true
config.disable_default_mouse_bindings = true

config.leader = { key = "[", mods = "CTRL", timeout_milliseconds = 1500 }
config.keys = {
  -- workspace
  {
    key = "q",
    mods = "LEADER",
    action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
  },
  {
    key = "e",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "(wezterm) Set workspace title:",
      action = wezterm.action_callback(function(win, pane, line)
        if line then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    }),
  },
  {
    key = "a",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "(wezterm) Create new workspace:",
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
  -- window
  {
    key = "F11",
    mods = "NONE",
    action = act.ToggleFullScreen,
  },
  -- tab
  {
    key = "t",
    mods = "LEADER",
    action = act({ SpawnTab = "CurrentPaneDomain" }),
  },
  {
    key = "w",
    mods = "LEADER",
    action = act({ CloseCurrentTab = { confirm = true } }),
  },
  {
    key = "Tab",
    mods = "LEADER",
    action = act.ActivateTabRelative(1),
  },
  {
    key = "Tab",
    mods = "LEADER|SHIFT",
    action = act.ActivateTabRelative(-1),
  },
  {
    key = "]",
    mods = "LEADER",
    action = act({ MoveTabRelative = 1 }),
  },
  {
    key = "[",
    mods = "LEADER",
    action = act({ MoveTabRelative = -1 }),
  },
  -- pane
  {
    key = "s",
    mods = "LEADER",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "v",
    mods = "LEADER",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "c",
    mods = "LEADER",
    action = act({ CloseCurrentPane = { confirm = true } }),
  },
  {
    key = "n",
    mods = "LEADER",
    action = act.PaneSelect,
  },
  {
    key = "z",
    mods = "LEADER",
    action = act.TogglePaneZoomState,
  },
  {
    key = "f",
    mods = "LEADER",
    action = act({ ScrollByPage = 1 })
  },
  {
    key = "b",
    mods = "LEADER",
    action = act({ ScrollByPage = -1 })
  },
  -- key table
  {
    key = "u",
    mods = "LEADER",
    action = act.ActivateCopyMode,
  },
  {
    key = "i",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
  },
  {
    key = "o",
    mods = "LEADER",
    action = act.ActivateKeyTable({ name = "activate_pane", timeout_milliseconds = 1000 }),
  },
  -- misc
  {
    key = "m",
    mods = "LEADER",
    action = act.ActivateCommandPalette,
  },
  {
    key = "l",
    mods = "LEADER|SHIFT",
    action = act.ShowDebugOverlay,
  },
  {
    key = "u",
    mods = "LEADER|SHIFT",
    action = act.CharSelect,
  },
  {
    key = "l",
    mods = "LEADER",
    action = act.Multiple {
      act.ClearScrollback "ScrollbackAndViewport",
      act.SendKey { key = "l", mods = "CTRL|SHIFT" },
    },
  },
  {
    key = "r",
    mods = "LEADER",
    action = act.ReloadConfiguration,
  },
  {
    key = "y",
    mods = "LEADER",
    action = act.CopyTo("Clipboard"),
  },
  {
    key = "p",
    mods = "LEADER",
    action = act.PasteFrom("Clipboard"),
  },
}
config.key_tables = {
  resize_pane = {
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "Escape", action = "PopKeyTable" },
  },
  activate_pane = {
    { key = "h", action = act.ActivatePaneDirection("Left") },
    { key = "l", action = act.ActivatePaneDirection("Right") },
    { key = "k", action = act.ActivatePaneDirection("Up") },
    { key = "j", action = act.ActivatePaneDirection("Down") },
  },
  copy_mode = {
    { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
    { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
    { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
    { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
    { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
    { key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
    { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
    { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
    { key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
    { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
    { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
    { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
    { key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
    { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
    { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
    { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
    { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
    { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
    -- jump
    { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
    { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
    { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
    { key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
    { key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
    -- viewport
    { key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
    { key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
    { key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
    -- mode
    { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
    { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
    { key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
    -- copy
    { key = "y", mods = "NONE", action = act.CopyTo("Clipboard") },
    -- quit
    { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
  },
}
config.mouse_bindings = {
  -- left
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.SelectTextAtMouseCursor("Cell"),
  },
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "SHIFT",
    action = act.ExtendSelectionToMouseCursor("Cell"),
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
  -- right
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom("PrimarySelection"),
  },
}

return config