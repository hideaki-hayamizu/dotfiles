return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>mf",
      function()
        require("fzf-lua").files()
      end,
      desc = "Fzf: find files",
    },
    {
      "<leader>mg",
      function()
        require("fzf-lua").grep()
      end,
      desc = "Fzf: rg ",
    },
    {
      "<leader>ml",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Fzf: live grep",
    },
    {
      "<leader>mh",
      function()
        require("fzf-lua").history()
      end,
      desc = "Fzf: buffers/files history",
    },
  },
  config = function ()
    local FzfLua = require("fzf-lua")

    FzfLua.setup({
      winopts = {
        border = "rounded",
        title = "",
        title_flags = false,
        preview = {
          border = "rounded",
          wrap = vim.o.wrap,
          layout = "horizontal",
          title = false,
          scrollbar = false,
          scrolloff = vim.o.scrolloff,
          winopts = {
            number            = vim.o.number,
            relativenumber    = vim.o.relativenumber,
            cursorline        = vim.o.cursorline,
            signcolumn        = "no",
            list              = false,
            foldenable        = false,
            foldmethod        = vim.o.foldmethod,
          },
        }
      },
    })
  end
}