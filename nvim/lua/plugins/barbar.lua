return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  version = '^1.0.0',
  init = function()
    vim.g.barbar_auto_setup = false

    vim.keymap.set('n', '<leader-p>', '<cmd>BufferPin<CR>', { silent = true })
  end,
  opts = {
    animation = false,
    exclude_ft = {},
    exclude_name = {},
    hide = {extensions = true, inactive = false},
    highlight_alternate = false,
  }
}