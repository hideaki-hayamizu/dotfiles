return {
  'nvim-telescope/telescope.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  init = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
  end,
  config = function()
    local telescope = require('telescope')
    local open_with_trouble = require("trouble.sources.telescope").open

    telescope.setup({
      defaults = {
        mappings = {
          i = { ["<c-t>"] = open_with_trouble },
          n = { ["<c-t>"] = open_with_trouble },
        },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
        }
      },
      extensions = {
        fzf = {
          case_mode = "respect_case",
        }
      }
    })
    telescope.load_extension('fzf')
  end
}