return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    local map = vim.keymap.set
    map('n', '<leader>ltd', '<cmd>Lspsaga peek_type_definition<CR>')
    map('n', '<leader>lgd', '<cmd>Lspsaga goto_definition')
  end,
  opts = {
    ui = {
      code_action = '',
      actionfix = '',
      expand = '',
      collapse = '',
    },
  }
}