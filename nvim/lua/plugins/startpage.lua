local function calc_padding(section)
  local padding = math.ceil((vim.o.lines - vim.o.cmdheight - #section.header.val - #section.buttons.val * 2 - 2) / 5)
  if padding > 0 then
    return padding
  else
    return 0
  end
end

return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "ibhagwan/fzf-lua"
  },
  config = function()
    local dash = require("alpha.themes.dashboard")

    dash.section.header.val = {
      [[⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ]],
      [[⢻⣿⡗⢶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣄]],
      [[⢻⣇⠀⠈⠙⠳⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠶⠛⠋⣹⣿⡿]],
      [[⠹⣆⠀⠀⠀⠀⠙⢷⣄⣀⣀⣀⣤⣤⣤⣄⣀⣴⠞⠋⠉⠀⠀⠀⢀⣿⡟⠁]],
      [[⠀⠙⢷⡀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠋⠀⠀  ]],
      [[⠀⠀⠈⠻⡶⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣠⡾⠋⠀⠀⠀⠀  ]],
      [[⠀⠀⠀⣼⠃⠀⢠⠒⣆⠀⠀⠀⠀⠀⠀⢠⢲⣄⠀⠀⠀⢻⣆⠀⠀⠀⠀⠀  ]],
      [[⠀⠀⢰⡏⠀⠀⠈⠛⠋⠀⢀⣀⡀⠀⠀⠘⠛⠃⠀⠀⠀⠈⣿⡀⠀⠀⠀⠀ ]],
      [[⠀⠀⣾⡟⠛⢳⠀⠀⠀⠀⠀⣉⣀⠀⠀⠀⠀⣰⢛⠙⣶⠀⢹⣇⠀⠀⠀⠀  ]],
      [[⠀⠀⢿⡗⠛⠋⠀⠀⠀⠀⣾⠋⠀⢱⠀⠀⠀⠘⠲⠗⠋⠀⠈⣿⠀⠀⠀⠀  ]],
      [[⠀⠀⠘⢷⡀⠀⠀⠀⠀⠀⠈⠓⠒⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡇⠀⠀⠀  ]],
      [[⠀⠀⠀⠈⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⠀⠀⠀   ]],
      [[⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀]]
    }
    dash.section.buttons.val = {
      dash.button("n", "New file", "<cmd>ene <CR>"),
      dash.button("f", "Find files", function()
        require("fzf-lua").files()
      end),
      dash.button("g", "Live Grep", function()
        require("fzf-lua").live_grep()
      end),
      dash.button("h", "History", function()
        require("fzf-lua").history()
      end),
      dash.button("l", "Lazy", "<cmd>Lazy sync<CR>"),
      dash.button("Q", "Quit", "<cmd>q<CR>")
    }
    dash.section.footer.val = "Neovim " .. vim.version().build

    dash.opts.layout = {
      { type = "padding", val = calc_padding(dash.section) },
      dash.section.header,
      { type = "padding", val = calc_padding(dash.section) },
      dash.section.buttons,
      { type = "padding", val = calc_padding(dash.section) },
      dash.section.footer,
      { type = "padding", val = calc_padding(dash.section) },
    }
    dash.opts.opts = {
      margin = 0,
    }

    require("alpha").setup(dash.config)
  end
}