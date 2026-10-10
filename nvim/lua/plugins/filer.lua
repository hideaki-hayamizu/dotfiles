local function my_open_win_config()
  local screen_width = vim.opt.columns:get()
  local screen_height = vim.opt.lines:get() - vim.opt.cmdheight:get()
  local tree_width = math.floor(screen_width * 0.8)
  local tree_height = math.floor(screen_height * 0.6)

  return{
    border = "rounded",
    relative = "editor",
    width = tree_width,
    height = tree_height,
    col = (screen_width - tree_width) / 2,
    row = (screen_height - tree_height) / 2
  }
end

local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local function edit_or_open()
  local node = api.tree.get_node_under_cursor()
  if not node then return end

  if node.nodes ~= nil then
    api.node.open.edit()
  else
    api.node.open.edit()
    api.tree.close()
  end
end

  local mappings = {
    ["<CR>"] = { edit_or_open, "Open" },
    ["<2-LeftMouse>"] = { edit_or_open, "Open" },
    ["l"] = { edit_or_open, "Open" },
    ["<C-t>"] = { api.node.open.tab, "Open: New Tab" },
    ["<C-v>"] = { api.node.open.vertical, "Open: Vertical Split" },
    ["<C-x>"] = { api.node.open.horizontal, "Open: Horizontal Split" },
    ["q"] = { api.tree.close, "Close" },
    ["h"] = { api.tree.close, "Close" },
    ["P"] = { api.node.navigate.parent, "Parent Directory" },
    ["<BS>"] = { api.node.navigate.parent_close, "Close Directory" },
    ["n"] = { api.fs.create, "Create" },
    ["D"] = { api.fs.remove, "Delete" },
    ["d"] = { api.fs.trash, "Trash" },
    ["r"] = { api.fs.rename, "Rename" },
    ["e"] = { api.fs.rename_basename, "Rename: Basename" },
    ["x"] = { api.fs.cut, "Cut" },
    ["y"] = { api.fs.copy.node, "Copy" },
    ["p"] = { api.fs.paste, "Paste" },
    ["gY"] = { api.fs.copy.filename, "Copy Name" },
    ["Y"] = { api.fs.copy.relative_path, "Copy Relative Path" },
    ["gy"] = { api.fs.copy.absolute_path, "Copy Absolute Path" },
    ["S"] = { api.tree.search_node, "Search" },
    ["f"] = { api.live_filter.start, "Filter" },
    ["F"] = { api.live_filter.clear, "Clean Filter" },
    ["H"] = { api.tree.toggle_hidden_filter, "Toggle Dotfiles" },
    ["U"] = { api.tree.toggle_custom_filter, "Toggle Hidden" },
    ["I"] = { api.tree.toggle_gitignore_filter, "Toggle Git Ignore" },
    ["R"] = { api.tree.reload, "Refresh" },
    ["<C-k>"] = { api.node.show_info_popup, "Info" },
    ["g?"] = { api.tree.toggle_help, "Help" },
  }

  for keys, mapping in pairs(mappings) do
    vim.keymap.set("n", keys, mapping[1], opts(mapping[2]))
  end
end

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "^1",
  keys = {
    {
      "<C-h>",
      function()
        local api = require("nvim-tree.api")

        local currentBuf = vim.api.nvim_get_current_buf()
        local currentBufFt = vim.api.nvim_get_option_value("filetype", { buf = currentBuf })
        if currentBufFt == "NvimTree" then
          api.tree.toggle()
        else
          api.tree.focus()
        end
      end,
      desc = "nvim-tree: Focus/Toggle NvimTree",
    },
  },
  config = function ()
    require("nvim-tree").setup({
      filesystem_watchers = {
        enable = true,
        ignore_dirs = { "tmp", "temp", ".cache", "Temp" },
      },
      view = {
        signcolumn = "yes",
        float = {
          enable = true,
          open_win_config = my_open_win_config,
        },
        cursorline = false,
      },
      modified = {
        enable = true,
      },
      renderer = {
        indent_width = 2,
        icons = {
          show = {
            hidden = true
          },
          git_placement = "after",
          bookmarks_placement = "after",
          symlink_arrow = "",
          glyphs = {
            folder = {
              arrow_closed = " ",
              arrow_open = " ",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = ""
            },
            default = "",
            symlink = "",
            bookmark = "",
            modified = "",
            hidden = "󱙝",
            git = {
              unstaged = "",
              staged = "",
              unmerged = "󰆑",
              untracked = "",
              renamed = "",
              deleted = "",
              ignored = ""
            }
          }
        }
      },
      ui = {
        confirm = {
          remove = true,
          trash = false,
        },
      },
      on_attach = my_on_attach,
      filters = {
        dotfiles = false,
        git_ignored = false,
        custom = { "^\\.git$", "^tmp$", "^temp$", "^Temp$" },
      },
      hijack_cursor = true,
      sync_root_with_cwd = true,
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = false,
      },
      system_open = vim.fn.has("mac") == 1 and  {
        cmd = "open",
        args = { "-R" },
      } or nil
    })

    local api = require("nvim-tree.api")

    -- automatically resize the floating window
    vim.api.nvim_create_augroup("NvimTreeResize", {
      clear = true,
    })
    vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
      group = "NvimTreeResize",
      callback = function()
        -- Get the nvim-tree window ID
        local winid = api.tree.winid()
        if (winid) then
          api.tree.reload()
        end
      end
    })

    -- automatically open file upon creation
    api.events.subscribe(api.events.Event.FileCreated, function(file)
      vim.cmd("edit " .. vim.fn.fnameescape(file.fname))
    end)
  end
}