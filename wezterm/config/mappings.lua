local wezterm = require('wezterm')
local act = wezterm.action
local colors = require('colors')
local utils = require('utils')

local zen_mode = utils.flag.instance

wezterm.on('switch-theme', function(window, pane)
  local choices = {}

  for _, v in ipairs(wezterm.glob(wezterm.config_dir .. '/colors/*.lua')) do
    local mod = utils.format.get_file_name(v)
    if mod ~= 'init' then
      table.insert(choices, {
        id = mod,
        label = mod,
      })
    end
  end

  window:perform_action(
    act.InputSelector({
      action = wezterm.action_callback(function(window, pane, id, label)
        colors.save_color_scheme(label)
        local overrides = window:get_config_overrides() or {}
        overrides.color_scheme = colors.get_color_scheme(colors.get_appearance()) or nil
        overrides.command_palette_bg_color = colors.get_palette(colors.get_appearance()).bg
        overrides.command_palette_fg_color = colors.get_palette(colors.get_appearance()).fg
        window:set_config_overrides(overrides)
      end),
      title = 'color_scheme',
      choices = choices,
      fuzzy = true,
      description = 'Select a color_scheme and press Enter = accept, Esc = cancel, / = filter'
    }),
    pane
  )
end)

wezterm.on('zen-mode', function(window, pane)
  local id = 'zen_mode' .. window:window_id()
  local current = zen_mode:get(id)

  if current == nil then
    current = false
  end

  zen_mode:set(id, not current)

  local overrides = window:get_config_overrides() or {}
  if zen_mode:get(id) then
    overrides.keys = {
      {
        key = 'z',
        mods = 'LEADER',
        action = act.EmitEvent('zen-mode'),
      },
    }
    overrides.key_tables = {}
    overrides.mouse_bindings = {}
  else
    overrides.keys = nil
    overrides.key_tables = nil
    overrides.mouse_bindings = nil
  end
  window:set_config_overrides(overrides)
end)

local config = {}

config.leader = { key = '.', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- workspace
  {
    key = 'p',
    mods = 'LEADER',
    action = act.PromptInputLine({
      description = '(wezterm) Create new workspace:',
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
    key = 'o',
    mods = 'LEADER',
    action = act.ShowLauncherArgs({ flags = 'WORKSPACES', title = 'Select workspace' }),
  },
  {
    key = 'i',
    mods = 'LEADER',
    action = act.PromptInputLine({
      description = '(wezterm) Set workspace title:',
      action = wezterm.action_callback(function(win, pane, line)
        if line then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    }),
  },
  -- window
  { key = 'f', mods = 'LEADER', action = act.ToggleFullScreen },
  -- tab
  {
    key = 'T',
    mods = 'SHIFT|CTRL',
    action = act.SpawnTab('CurrentPaneDomain'),
  },
  {
    key = 'W',
    mods = 'SHIFT|CTRL',
    action = act.CloseCurrentTab({ confirm = true }),
  },
  { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = '{', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(1) },
  -- pane
  { key = 's', mods = 'LEADER', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = 'w', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = ']', mods = 'LEADER', action = act.PaneSelect },
  { key = 'Z', mods = 'SHIFT|CTRL', action = act.TogglePaneZoomState },
  { key = 'l', mods = 'CTRL', action = act.ClearScrollback('ScrollbackAndViewport') },
  { key = 'U', mods = 'SHIFT|CTRL', action = act.ScrollByLine(-1) },
  { key = 'D', mods = 'SHIFT|CTRL', action = act.ScrollByLine(1) },
  -- font
  { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
  -- reload configuration
  { key = 'R', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
  -- show debug overlay
  { key = 'L', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
  -- show command palette
  { key = 'P', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
  -- copy and paste
  { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo('Clipboard') },
  { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom('Clipboard') },
  -- key tables
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable({ name = 'resize_pane', one_shot = false }) },
  {
    key = 'a',
    mods = 'LEADER',
    action = act.ActivateKeyTable({ name = 'activate_pane', timeout_milliseconds = 1000 }),
  },
  -- event
  {
    key = 'z',
    mods = 'LEADER',
    action = act.EmitEvent('zen-mode'),
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.EmitEvent('switch-theme'),
  },
}

config.key_tables = {
  activate_pane = {
    { key = 'h', action = act.ActivatePaneDirection('Left') },
    { key = 'j', action = act.ActivatePaneDirection('Down') },
    { key = 'k', action = act.ActivatePaneDirection('Up') },
    { key = 'l', action = act.ActivatePaneDirection('Right') },
  },
  resize_pane = {
    { key = 'h', action = act.AdjustPaneSize({ 'Left', 1 }) },
    { key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },
    { key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },
    { key = 'l', action = act.AdjustPaneSize({ 'Right', 1 }) },
    { key = 'Escape', action = 'PopKeyTable' },
  },
  copy_mode = {
    -- cursor
    { key = 'h', mods = 'NONE', action = act.CopyMode('MoveLeft') },
    { key = 'j', mods = 'NONE', action = act.CopyMode('MoveDown') },
    { key = 'k', mods = 'NONE', action = act.CopyMode('MoveUp') },
    { key = 'l', mods = 'NONE', action = act.CopyMode('MoveRight') },
    { key = '^', mods = 'SHIFT', action = act.CopyMode('MoveToStartOfLineContent') },
    { key = '$', mods = 'SHIFT', action = act.CopyMode('MoveToEndOfLineContent') },
    { key = '0', mods = 'NONE', action = act.CopyMode('MoveToStartOfLine') },
    { key = 'o', mods = 'NONE', action = act.CopyMode('MoveToSelectionOtherEnd') },
    { key = 'O', mods = 'SHIFT', action = act.CopyMode('MoveToSelectionOtherEndHoriz') },
    { key = 'g', mods = 'NONE', action = act.CopyMode('MoveToScrollbackTop') },
    { key = 'G', mods = 'SHIFT', action = act.CopyMode('MoveToScrollbackBottom') },
    -- scroll
    { key = 'b', mods = 'CTRL', action = act.CopyMode('PageUp') },
    { key = 'f', mods = 'CTRL', action = act.CopyMode('PageDown') },
    { key = 'd', mods = 'CTRL', action = act.CopyMode({ MoveByPage = 0.5 }) },
    { key = 'u', mods = 'CTRL', action = act.CopyMode({ MoveByPage = -0.5 }) },
    -- viewport
    { key = 'H', mods = 'SHIFT', action = act.CopyMode('MoveToViewportTop') },
    { key = 'L', mods = 'SHIFT', action = act.CopyMode('MoveToViewportBottom') },
    { key = 'M', mods = 'SHIFT', action = act.CopyMode('MoveToViewportMiddle') },
    -- jump
    { key = ';', mods = 'NONE', action = act.CopyMode('JumpAgain') },
    { key = 'w', mods = 'NONE', action = act.CopyMode('MoveForwardWord') },
    { key = 'b', mods = 'NONE', action = act.CopyMode('MoveBackwardWord') },
    { key = 'e', mods = 'NONE', action = act.CopyMode('MoveForwardWordEnd') },
    { key = 't', mods = 'NONE', action = act.CopyMode({ JumpForward = { prev_char = true } }) },
    { key = 'f', mods = 'NONE', action = act.CopyMode({ JumpForward = { prev_char = false } }) },
    { key = 'T', mods = 'SHIFT', action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
    { key = 'F', mods = 'SHIFT', action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
    -- mode
    { key = 'v', mods = 'NONE', action = act.CopyMode({ SetSelectionMode = 'Cell' }) },
    { key = 'v', mods = 'CTRL', action = act.CopyMode({ SetSelectionMode = 'Block' }) },
    { key = 'V', mods = 'SHIFT', action = act.CopyMode({ SetSelectionMode = 'Line' }) },
    -- copy
    { key = 'y', mods = 'NONE', action = act.CopyTo('Clipboard') },
    { key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },
  }
}

config.mouse_bindings = {
  -- left
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor('Cell'),
  },
  {
    event = { Down = { streak = 2, button = 'Left' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor('Word'),
  },
  {
    event = { Down = { streak = 3, button = 'Left' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor('Line'),
  },
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'SHIFT',
    action = act.ExtendSelectionToMouseCursor('Cell'),
  },
  {
    event = { Drag = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.ExtendSelectionToMouseCursor('Cell'),
  },
  -- wheel
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'NONE',
    action = act.ScrollByLine(-1),
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'NONE',
    action = act.ScrollByLine(1),
  },
  -- right
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom('Clipboard'),
  },
}

return config