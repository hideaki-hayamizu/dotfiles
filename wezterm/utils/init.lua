local M = {}
local wezterm = require("wezterm")

local os_name = wezterm.target_triple
M.is_windows = os_name:find("windows") ~= nil
M.is_macos = os_name:find("darwin") ~= nil
M.is_linux = os_name:find("linux") ~= nil
M.is_wsl = wezterm.running_under_wsl()


local function is_list(t)
  if type(t) ~= "table" then
    return false
  end

  local n = 0

  for k in pairs(t) do
    if type(k) ~= "number" or k < 1 or k % 1 ~= 0 then
      return false
    end

    n = n + 1
  end

  return n > 0 and n == #t
end

local function deep_copy(v)
  if type(v) ~= "table" then
    return v
  end

  local c = {}

  for k, x in pairs(v) do
    c[deep_copy(k)] = deep_copy(x)
  end

  return c
end

M.merge_tables = function (t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      if is_list(v) or type(t1[k]) ~= "table" or is_list(t1[k]) then
        t1[k] = deep_copy(v)
      else
        M.merge_tables(t1[k], v)
      end
    else
      t1[k] = v
    end
  end

  return t1
end

M.basename = function (path)
  return path:gsub("(.*[/\\])(.*)", "%2")
end

M.read_lines = function (path)
  local f = io.open(path, "r")
  if not f then
    return nil
  end

  local lines = {}
  for line in f:lines() do
    line = line:gsub("\r$", "")
    table.insert(lines, line)
  end

  f:close()

  return lines
end

M.write_lines = function (path, lines)
  local f = io.open(path, "w")
  if not f then
    return
  end

  for _, line in ipairs(lines) do
    f:write(line, "\n")
  end

  f:close()
end

M.ensure_line = function (path, line_no, v)
  local lines = M.read_lines(path) or {}

  local current = lines[line_no]
  if current and current:match("%S") then
    return
  end

  for i = #lines + 1, line_no - 1 do
    lines[i] = ""
  end
  lines[line_no] = v

  M.write_lines(path, lines)
end

M.is_window_maximized = function (window)
  local dims = window:get_dimensions()
  local screen = wezterm.gui.screens().active
  return dims.pixel_width >= screen.width * 0.95 and dims.pixel_height >= screen.height * 0.90
end

return M