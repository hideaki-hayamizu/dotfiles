return {
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      fallback = "light",
    }
  },
  {
    "folke/which-key.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "^3",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    opts = {
      preset = "helix",
    }
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input" },
    }
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {
      opts = {
        enable_close_on_slash = true,
      },
      per_filetype = {}
    }
  },
  {
    "kylechui/nvim-surround",
    version = "^4",
    event = "InsertEnter",
    opts = {}
  }
}
