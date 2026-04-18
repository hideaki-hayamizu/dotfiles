local servers = {
  'ast-grep', 'shfmt', 'shellcheck', 'clang-format',
  'cpplint', 'cmakelang', 'htmlhint', 'stylelint',
  'eslint_d', 'prettier', 'trivy', 'selene', 'stylua', 'mbake',
  'markdownlint', 'pyproject-fmt', 'sqruff', 'vint'
}

return {
  "jay-babu/mason-null-ls.nvim",
  dependencies = {
    "mason-org/mason.nvim",
    "nvimtools/none-ls.nvim",
  },
  init = function ()
    vim.lsp.buf.format({ timeout_ms = 2000 })

    local fmt_group = vim.api.nvim_create_augroup("LspFormatting", {})
    require("null-ls").setup({
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = fmt_group, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = fmt_group,
            buffer = bufnr,
            callback = function()
              -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
              -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
              -- vim.lsp.buf.formatting_sync()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })
  end,
  opts = {
    ensure_installed = servers,
    automatic_installation = true,
  }
}