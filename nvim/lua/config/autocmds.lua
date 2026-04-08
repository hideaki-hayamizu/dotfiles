vim.api.nvim_create_autocmd('TermOpen',{
  group = vim.api.nvim_create_augroup('Terminal', { clear = true }),
  callback = function()
    vim.cmd.startinsert()
  end
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end
})