return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        background_colour = "#000000",
        stages = "fade",
      },
      config = function (_, opts)
        require("notify").setup(opts)

        vim.keymap.set("n", "<Leader>dn", function ()
          require("notify").dismiss({ silent = true })
        end, { desc = "Dismiss notifications" })
      end
    }
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      lsp_doc_border = true
    },
  }
}