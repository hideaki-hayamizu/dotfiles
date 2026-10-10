return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      globalstatus = true,
      refresh = {
        events = {
          "OptionSet",
          "WinEnter",
          "BufEnter",
          "BufWritePost",
          "SessionLoadPost",
          "FileChangedShellPost",
          "VimResized",
          "Filetype",
          "CursorMoved",
          "CursorMovedI",
          "ModeChanged",
        },
      }
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        "branch", {
          "diff",
          symbols = { added = "A", modified = "M", removed = "R" },
        }, {
          "diagnostics",
          symbols = { error = "E", warn = "W", info = "I", hint = "H" },
        }
      },
      lualine_c = { "%=", {
        "filename",
        symbols = {
          modified = "",
          readonly = "",
          unnamed = "",
          newfile = ""
        }
      } },
      lualine_x = { "searchcount", "selectioncount", {
        "lsp_status",
        icon = "",
        symbols = {
          done = "",
        },
      } },
      lualine_y = { {
        "encoding",
        show_bomb = true,
      }, {
        "fileformat",
        symbols = {
          unix = "󰻀",
          dos = "",
          mac = ""
        }
      }, "filetype" },
      lualine_z = { "location", "progress" }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    },
    extensions = {
      "fzf", "lazy", "mason", "nvim-tree", "quickfix", "trouble", "nvim-dap-ui"
    }
  }
}