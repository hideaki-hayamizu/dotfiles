local servers = {
  'python', 'js',
  'bash', 'codelldb',
}

return {
  'jay-babu/mason-nvim-dap.nvim',
  dependencies = {
    "mason-org/mason.nvim",
    "mfussenegger/nvim-dap",
  },
  opts = {
    ensure_installed = servers,
    automatic_installation = true,
    handlers = {
      function(config)
        require('mason-nvim-dap').default_setup(config)
      end,
    },
  }
}