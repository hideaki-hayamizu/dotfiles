local M = {}

function M.merge_tables(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == 'table' and type(t1[k]) == 'table' then
      M.merge_tables(t1[k], v)
    else
      t1[k] = v
    end
  end
  return t1
end

function M.merge_lists(t1, t2)
  local re = {}
  for _, v in ipairs(t1) do
    table.insert(re, v)
  end
  for _, v in ipairs(t2) do
    table.insert(re, v)
  end
  return re
end

return M