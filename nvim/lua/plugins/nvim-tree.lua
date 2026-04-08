local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

local function open_win_config_func()
  local screen_w = vim.opt.columns:get()
  local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
  local tree_w = screen_w * WIDTH_RATIO
  local tree_h = screen_h * HEIGHT_RATIO
  return {
    border = "double",
    relative = "editor",
    width = math.floor(tree_w),
    height = math.floor(tree_h),
    col = (screen_w - tree_w) / 2,
    row = ((vim.opt.lines:get() - tree_h) / 2) - vim.opt.cmdheight:get()
  }
end

local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local function clear_and_copy()
    api.fs.clear_clipboard()
    api.fs.copy.node()
  end

  local function clear_and_cut()
    api.fs.clear_clipboard()
    api.fs.cut()
  end

  local mappings = {
    -- default mappings
    ["<C-]>"] = { api.tree.change_root_to_node, "CD" },
    ["<C-e>"] = { api.node.open.replace_tree_buffer, "Open: In Place" },
    ["<C-k>"] = { api.node.show_info_popup, "Info" },
    ["<C-r>"] = { api.fs.rename_sub, "Rename: Omit Filename" },
    ["<C-t>"] = { api.node.open.tab, "Open: New Tab" },
    ["<C-v>"] = { api.node.open.vertical, "Open: Vertical Split" },
    ["<C-x>"] = { api.node.open.horizontal, "Open: Horizontal Split" },
    ["<BS>"] = { api.node.navigate.parent_close, "Close Directory" },
    ["<CR>"] = { api.node.open.edit, "Open" },
    ["<Tab>"] = { api.node.open.preview, "Open Preview" },
    [">"] = { api.node.navigate.sibling.next, "Next Sibling" },
    ["<"] = { api.node.navigate.sibling.prev, "Previous Sibling" },
    ["."] = { api.node.run.cmd, "Run Command" },
    ["-"] = { api.tree.change_root_to_parent, "Up" },
    ["a"] = { api.fs.create, "Create" },
    ["bmv"] = { api.marks.bulk.move, "Move Bookmarked" },
    ["B"] = { api.tree.toggle_no_buffer_filter, "Toggle No Buffer" },
    -- ["c"] = { api.fs.copy.node, "Copy" },
    ["C"] = { api.tree.toggle_git_clean_filter, "Toggle Git Clean" },
    ["[c"] = { api.node.navigate.git.prev, "Prev Git" },
    ["]c"] = { api.node.navigate.git.next, "Next Git" },
    ["d"] = { api.fs.remove, "Delete" },
    ["D"] = { api.fs.trash, "Trash" },
    ["E"] = { api.tree.expand_all, "Expand All" },
    ["e"] = { api.fs.rename_basename, "Rename: Basename" },
    ["]e"] = { api.node.navigate.diagnostics.next, "Next Diagnostic" },
    ["[e"] = { api.node.navigate.diagnostics.prev, "Prev Diagnostic" },
    ["F"] = { api.live_filter.clear, "Clean Filter" },
    ["f"] = { api.live_filter.start, "Filter" },
    ["g?"] = { api.tree.toggle_help, "Help" },
    ["gy"] = { api.fs.copy.absolute_path, "Copy Absolute Path" },
    ["H"] = { api.tree.toggle_hidden_filter, "Toggle Dotfiles" },
    ["I"] = { api.tree.toggle_gitignore_filter, "Toggle Git Ignore" },
    ["J"] = { api.node.navigate.sibling.last, "Last Sibling" },
    ["K"] = { api.node.navigate.sibling.first, "First Sibling" },
    ["m"] = { api.marks.toggle, "Toggle Bookmark" },
    ["o"] = { api.node.open.edit, "Open" },
    ["O"] = { api.node.open.no_window_picker, "Open: No Window Picker" },
    ["p"] = { api.fs.paste, "Paste" },
    ["P"] = { api.node.navigate.parent, "Parent Directory" },
    ["q"] = { api.tree.close, "Close" },
    ["r"] = { api.fs.rename, "Rename" },
    ["R"] = { api.tree.reload, "Refresh" },
    ["s"] = { api.node.run.system, "Run System" },
    ["S"] = { api.tree.search_node, "Search" },
    ["U"] = { api.tree.toggle_custom_filter, "Toggle Hidden" },
    ["W"] = { api.tree.collapse_all, "Collapse" },
    -- ["x"] = { api.fs.cut, "Cut" },
    ["y"] = { api.fs.copy.filename, "Copy Name" },
    ["Y"] = { api.fs.copy.relative_path, "Copy Relative Path" },
    ["<2-LeftMouse>"] = { api.node.open.edit, "Open" },
    ["<2-RightMouse>"] = { api.tree.change_root_to_node, "CD" },

    -- custom mappings
    ["?"] = { api.tree.toggle_help, "Help" },
    ["c"] = { clear_and_copy, "Copy" },
    ["x"] = { clear_and_cut, "cut" },
  }

  for keys, mapping in pairs(mappings) do
    vim.keymap.set("n", keys, mapping[1], opts(mapping[2]))
  end
end

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    -- automatically resize the floating window when neovim's window size changes
    local api = require("nvim-tree.api")

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

    vim.keymap.set('n', '<C-b>', '<cmd>NvimTreeToggle<CR>')
  end,
  config = function()
    require("nvim-tree").setup({
      view = {
        signcolumn = "yes",
        float = {
          enable = true,
          open_win_config = open_win_config_func
        },
        cursorline = false
      },
      modified = {
        enable = true
      },
      renderer = {
        indent_width = 2,
        icons = {
          show = {
            hidden = true
          },
          git_placement = "after",
          bookmarks_placement = "after",
          symlink_arrow = " -> ",
          glyphs = {
            folder = {
              arrow_closed = " ",
              arrow_open = " ",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "󰉍",
              symlink_open = ""
            },
            default = "",
            symlink = "",
            bookmark = "",
            modified = "",
            hidden = "",
            git = {
              unstaged = "",
              staged = "",
              unmerged = "󰧾",
              untracked = "",
              renamed = "",
              deleted = "",
              ignored = "∅"
            }
          }
        }
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
        custom = { "^\\.git$" }
      },
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = false,
      },
      on_attach = my_on_attach,
      hijack_cursor = true,
      sync_root_with_cwd = true
    })
  end,
}