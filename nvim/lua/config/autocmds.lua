vim.api.nvim_create_autocmd('TermOpen',{
  group = vim.api.nvim_create_augroup('Terminal', { clear = true }),
  callback = function()
    vim.cmd.startinsert()
  end
})