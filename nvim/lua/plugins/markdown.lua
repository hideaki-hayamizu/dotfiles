return {
  'mrjones2014/mdpreview.nvim',
  ft = 'markdown',
  dependencies = { 'norcalli/nvim-terminal.lua', config = true },
  init = function ()
    vim.keymap.set('n', 'mdp', '<cmd>Mdpreview<CR>')
    vim.keymap.set('n', 'mdq', '<cmd>Mdpreview!<CR>')
  end,
  opts = {
    cli_args = { 'glow', '-w', '1'},
    renderer = {
      opts = {
        winnr = function()
          vim.cmd('vsp')
          return vim.api.nvim_get_current_win()
        end,
        win_opts = {
          signcolumn = 'no',
          number = false,
          concealcursor = 'niv',
          wrap = true,
          linebreak = true,
        },
      }
    },
  }
}