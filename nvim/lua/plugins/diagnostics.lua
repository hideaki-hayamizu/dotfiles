return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<CR>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
      desc = "Buffer Diagnostics (Trouble)",
    },
  },
  opts = {},
  config = function(_, opts)
    require("trouble").setup(opts)

    vim.diagnostic.config({
      underline = true,
      signs = true,
      virtual_text = {
        spacing = 2,
        source = "if_many",
        prefix = "",
      },
      severity_sort = true,
      update_in_insert = true,
      float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
      },
      jump = {
        on_jump = function(_, bufnr)
          vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
        end,
      },
    })

    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float(nil, {
          focus = false,
          scope = "cursor",
        })
      end,
    })
  end,
}