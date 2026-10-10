return {
  {
    "alvarosevilla95/luatab.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      local ft_list = {
        checkhealth = "Checkhealth",
        git = "Git",
        NvimTree = "NvimTree",
        lazy = "Lazy",
        mason = "Mason"
      }

      require("luatab").setup({
        title = function(bufnr)
          local file = vim.fn.bufname(bufnr)
          local buftype = vim.fn.getbufvar(bufnr, "&buftype")
          local filetype = vim.fn.getbufvar(bufnr, "&filetype")

          if buftype == "help" then
            return "help:" .. vim.fn.fnamemodify(file, ":t:r")
          elseif buftype == "quickfix" then
            return "quickfix"
          elseif ft_list[filetype] then
            return ft_list[filetype]
          elseif file:sub(file:len()-2, file:len()) == "FZF" then
            return "FZF"
          elseif buftype == "terminal" then
            local _, mtch = string.match(file, "term:(.*):(%a+)")
            return mtch ~= nil and mtch or vim.fn.fnamemodify(vim.env.SHELL, ":t")
          elseif file == "" then
            return ""
          else
            return vim.fn.pathshorten(vim.fn.fnamemodify(file, ":p:~:t"))
          end
        end,
        modified = function(bufnr)
          return vim.fn.getbufvar(bufnr, "&modified") == 1 and "" or " "
        end,
        windowCount = function()
          return ""
        end,
        tabline = function()
          local line = ""
          for i = 1, vim.fn.tabpagenr("$"), 1 do
              line = line .. require("luatab").helpers.cell(i)
          end
          line = line .. "%#TabLineFill#%="
          return line
        end,
      })
    end
  },
  {
    "b0o/incline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cond = true,
    config = function ()
      vim.opt.showtabline = 0

      local helpers = require("incline.helpers")
      local devicons = require("nvim-web-devicons")

      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified

          local function get_git_diff()
            local icons = { removed = "R", changed = "M", added = "A" }
            local signs = vim.b[props.buf].gitsigns_status_dict
            local labels = {}
            if signs == nil then
              return labels
            end
            for name, icon in pairs(icons) do
              if tonumber(signs[name]) and signs[name] > 0 then
                table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
              end
            end
            if #labels > 0 then
              table.insert(labels, { "┊ " })
            end
            return labels
          end

          local function get_diagnostic_label()
            local icons = { error = "E", warn = "W", info = "I", hint = "H" }
            local label = {}

            for severity, icon in pairs(icons) do
              local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
              if n > 0 then
                table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
              end
            end
            if #label > 0 then
              table.insert(label, { "┊ " })
            end
            return label
          end

          local function get_hl_bg(name)
            local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
            if hl.bg then
              return string.format("#%06x", hl.bg)
            end
            return "#000000"
          end

          return {
            { get_diagnostic_label() },
            { get_git_diff() },
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            { filename .. " ", gui = modified and "bold,italic" or "bold" },
            modified and { "", gui = "bold" } or " ",
            guibg = get_hl_bg("CursorLine")
          }
        end,
      })
    end
  },
}
