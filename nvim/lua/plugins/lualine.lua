return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', {
        'diff',
        symbols = {added = ' ', modified = ' ', removed = ' '},
      }, {
        'diagnostics',
        symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '},
      }},
      lualine_c = {{
        'filename',
        symbols = {
          modified = '',
         readonly = '',
          unnamed = '',
          newfile = '',
        }
      }},
      lualine_x = {{
        'encoding',
        show_bomb = false
      }, 'fileformat', 'filetype'},
      lualine_y = {'searchcount', 'selectioncount', 'location'},
      lualine_z = {'progress', 'lsp_status'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {{
        'filename',
        symbols = {
          modified = '',
          readonly = '',
          unnamed = '',
          newfile = '',
        }
      }},
      lualine_x = {},
      lualine_y = {'location'},
      lualine_z = {}
    },
  }
}