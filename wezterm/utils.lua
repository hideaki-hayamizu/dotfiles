local wezterm = require("wezterm")

local M = {}

-- OS
M.is_windows = string.find(wezterm.target_triple, "windows") ~= nil
M.is_macos = string.find(wezterm.target_triple, "darwin") ~= nil

-- table
local function table_copy(tbl)
  local copy = {}

  if type(tbl) == "table" then
    for k, v in pairs(tbl) do
      copy[table_copy(k)] = table_copy(v)
    end
    setmetatable(copy, table_copy(getmetatable(tbl)))
  else
    copy = tbl
  end

  return copy
end

function M.merge_arrays(t1, t2)
  local result = {}

  for _, v in ipairs(t1) do
    table.insert(result, v)
  end
  for _, v in ipairs(t2) do
    table.insert(result, v)
  end

  return result
end

function M.merge_tables(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k]) == "table" then
        M.merge_tables(t1[k], v)
      else
        t1[k] = table_copy(v)
      end
    else
      t1[k] = v
    end
  end

  return t1
end

-- file
function M.read_file(path)
  local file = io.open(path, "r")

  if not file then
    return nil
  end

  local lines = {}

  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()

  return lines
end

function M.write_file(path, arr)
  local file = io.open(path, "w")

  if file then
    for _, v in ipairs(arr) do
      file:write(v .. "\n")
    end
    file:close()
  end
end

function M.basename(s)
  local unix = string.gsub(s, "(.*[/\\])(.*)", "%2")
  local windows = string.match(unix, "(.*)%.[^.]+$")
  return windows or unix
end

function M.invert_hex_color(hex)
  hex = string.gsub(hex, "#", "")
  local r = tonumber(string.sub(hex, 1, 2), 16)
  local g = tonumber(string.sub(hex, 3, 4), 16)
  local b = tonumber(string.sub(hex, 5, 6), 16)

  local i_r = string.format("%02x", 0xff - r)
  local i_g = string.format("%02x", 0xff - g)
  local i_b = string.format("%02x", 0xff - b)

  return "#" .. i_r .. i_g .. i_b
end

return M