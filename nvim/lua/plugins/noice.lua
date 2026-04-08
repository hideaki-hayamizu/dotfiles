return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        background_colour = "#000000",
      }
    },
  },
  init = function()
    vim.keymap.set("n", "<leader>nl", function()
      require("noice").cmd("last")
    end)

    vim.keymap.set("n", "<leader>nh", function()
      require("noice").cmd("history")
    end)
  end,
  opts = {
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = false,
    },
  }
}