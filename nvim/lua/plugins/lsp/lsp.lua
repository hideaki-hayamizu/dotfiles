local servers = {
  'bashls', 'clangd', 'cmake', 'cssls','dockerls', 'fish_lsp',
  'glsl_analyzer', 'html', 'ts_ls', 'jsonls', 'lua_ls', 'marksman', 'mesonlsp',
  'powershell_es', 'pyright', 'ruff', 'rust_analyzer', 'sqlls', 'taplo', 'vimls', 'yamlls'
}

return {
  'mason-org/mason-lspconfig.nvim',
  version = "^2",
  dependencies = {
    "mason-org/mason.nvim",
    {
      "neovim/nvim-lspconfig",
      dependencies = { 'saghen/blink.cmp' },
      version = "^2",
    },
  },
  config = function()
    require("mason-lspconfig").setup({
      automatic_enable = true,
      ensure_installed = servers,
    })
  end
}