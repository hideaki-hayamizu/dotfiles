local themes = {}
for _, f in ipairs(vim.fn.glob(vim.fn.stdpath('config') .. "/lua/plugins/colors/*.lua", false, true)) do
  local file_name = f:match('[^/\\]*%.lua$')
  local v = file_name:sub(1, #file_name - 4)
  table.insert(themes, v)
end

return {
  "zaldih/themery.nvim",
  lazy = false,
  init = function()
    vim.keymap.set('n', '<leader>-', '<cmd>Themery<CR>')
  end,
  config = function()
    require("themery").setup({
      themes = themes
    })
  end
}