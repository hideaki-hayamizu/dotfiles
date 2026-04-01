local M = {}

function M.base_name(s)
  return s:gsub('(.*[/\\])(.*)', '%2')
end

function M.get_file_name(f)
  local file_name = f:match('[^/\\]*.lua$')
  return file_name:sub(0, #file_name - 4)
end

return M