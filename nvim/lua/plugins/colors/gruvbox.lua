return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
  config = true,
  opts = {
    bold = false,
    inverse = true,
    invert_selection = true,
    invert_signs = true,
    invert_tabline = true,
    overrides = {
      ErrorMsg = {
        fg = vim.o.background == 'dark' and '#fb4934' or "#9d0006",
        bg = vim.o.background == 'dark' and '#282828' or '#fbf1c7'
      },
    }
  }
}