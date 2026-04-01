local M = {}
M.__index = M

function M.new()
  local self = setmetatable({}, M)
  self.store = {}
  return self
end

function M:exists(key)
  return self.store[key] ~= nil
end

function M:get(key)
  return self.store[key]
end

function M:set(key, value)
  self.store[key] = value
end

function M:remove(key)
  self.store[key] = nil
end

M.instance = M:new()
return M