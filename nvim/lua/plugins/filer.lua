return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<C-h>",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          source = "filesystem",
          position = "float",
        })
      end,
      desc = "Toggle Neo-tree",
    },
  },
  opts = {
    clipboard = {
      sync = "global"
    },
    close_if_last_window = true,
    enable_cursor_hijack = true,
    popup_border_style = "rounded",
    sort_case_insensitive = false,
    use_default_mappings = false,
    window = {
      position = "float",
      popup = {
        size = {
          height = "60%",
          width = "80%",
        },
        title = function (state)
          return "Neo-tree"
        end,
      },
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ["<CR>"] = "open",
        ["<2-LeftMouse>"] = "open",
        ["l"] = "open",
        ["v"] = "open_vsplit",
        ["s"] = "open_split",
        ["t"] = "open_tabnew",
        ["i"] = "open_with_window_picker",
        ["P"] = {
          "toggle_preview",
          config = {
            use_float = true,
            use_snacks_image = false,
            use_image_nvim = false
          }
        },
        ["<C-b>"] = { "scroll_preview", config = {direction = 10} },
        ["<C-f>"] = { "scroll_preview", config = {direction = -10} },
        ["F"] = "focus_preview",
        ["T"] = "toggle_node",
        ["w"] = "close_node",
        ["W"] = "close_all_nodes",
        ["f"] = "refresh",
        ["nf"] = {
          "add",
          config = {
            show_path = "none",
          }
        },
        ["nd"] = "add_directory",
        ["d"] = "trash",
        ["D"] = "delete",
        ["r"] = "rename",
        ["rb"] = "rename_basename",
        ["u"] = "undo",
        ["U"] = "restore_from_trash",
        ["mf"] = "select",
        ["mu"] = "clear_selection",
        ["<C-S-i>"] = "invert_selection",
        ["cy"] = "copy_to_clipboard",
        ["cx"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["cc"] = "clear_clipboard",
        ["y"] = "copy",
        ["x"] = "move",
        ["a"] = "toggle_auto_expand_width",
        ["<esc>"] = "cancel",
        ["q"] = "close_window",
        ["?"] = "show_help",
        ["<F1>"] = "show_help",
        ["<"] = "prev_source",
        [">"] = "next_source",
      }
    },
    filesystem = {
      hijack_netrw_behavior = "open_default",
      find_by_full_path_words = ".*",
      window = {
        mappings = {
          ["<F5>"] = "refresh",
          ["gh"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          ["g/"] = "fuzzy_finder_directory",
          ["#"] = "fuzzy_sorter",
          ["f"] = "filter_on_submit",
          ["<C-x>"] = "clear_filter",
          ["-"] = "navigate_up",
          ["<bs>"] = "navigate_up",
          ["gn"] = "set_root",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
          ["i"] = "show_file_details",
          ["rb"] = "rename_basename",
          ["sh"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "s" }},
          ["sc"] = { "order_by_created", nowait = false },
          ["sd"] = { "order_by_diagnostics", nowait = false },
          ["sg"] = { "order_by_git_status", nowait = false },
          ["sm"] = { "order_by_modified", nowait = false },
          ["sn"] = { "order_by_name", nowait = false },
          ["ss"] = { "order_by_size", nowait = false },
          ["st"] = { "order_by_type", nowait = false },
        },
        fuzzy_finder_mappings = {
          ["<down>"] = "move_cursor_down",
          ["<C-n>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-p>"] = "move_cursor_up",
          ["<Esc>"] = "close",
          ["<S-CR>"] = "close_keep_filter",
          ["<C-CR>"] = "close_clear_filter",
          ["<C-w>"] = { "<C-S-w>", raw = true },
          {
            n = {
              ["j"] = "move_cursor_down",
              ["k"] = "move_cursor_up",
              ["<S-CR>"] = "close_keep_filter",
              ["<C-CR>"] = "close_clear_filter",
              ["<esc>"] = "close",
            }
          }
        }
      },
      bind_to_cwd = true,
      check_gitignore_in_search = true,
      filtered_items = {
        visible = true,
        force_visible_in_empty_folder = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_ignored = false,
        hide_hidden = false,
      },
      always_show = {},
      always_show_by_pattern = {
        ".env*",
      },
    },
    buffers = {
      bind_to_cwd = true,
      window = {
        mappings = {
          ["-"] = "navigate_up",
          ["<bs>"] = "navigate_up",
          ["gn"] = "set_root",
          ["d"] = "buffer_delete",
          ["bd"] = "buffer_delete",
          ["i"] = "show_file_details",
          ["rb"] = "rename_basename",
          ["sh"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "s" }},
          ["sc"] = { "order_by_created", nowait = false },
          ["sd"] = { "order_by_diagnostics", nowait = false },
          ["sm"] = { "order_by_modified", nowait = false },
          ["sn"] = { "order_by_name", nowait = false },
          ["ss"] = { "order_by_size", nowait = false },
          ["st"] = { "order_by_type", nowait = false },
        },
      },
    },
    source_selector = {
      winbar = false,
      statusline = false,
      sources = {
        {
          source = "filesystem",
          display_name = "Files "
        },
        {
          source = "buffers",
          display_name = "Buffers "
        },
        {
          source = "git_status",
          display_name = "Git "
        },
      },
      content_layout = "start",
      tabs_layout = "start",
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function()
          require("neo-tree.command").execute({ action = "close" })
        end
      },
      {
        event = "file_renamed",
        handler = function(args)
          print(args.source, " renamed to ", args.destination)
        end
      },
      {
        event = "file_moved",
        handler = function(args)
          print(args.source, " moved to ", args.destination)
        end
      },
    },
    git_status = {
      window = {
        mappings = {
          -- no mappings
        },
      },
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added     = "Ad",
          deleted   = "De",
          modified  = "Mo",
          renamed   = "Rn",
          untracked = "Ut",
          ignored   = "Xf",
          unstaged  = "Ug",
          staged    = "Sg",
          conflict  = "C!",
        }
      },
      diagnostics = {
        symbols = {
          hint = "H",
          info = "I",
          warn = "W",
          error = "E",
        },
      },
      indent = {
        indent_size = 2,
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        folder_empty_open = "",
        selected = "",
        use_filtered_colors = true
      },
      modified = {
        symbol = "",
      },
      last_modified = {
        enabled = false,
      },
      created = {
        enabled = false,
      },
      symlink_target = {
        enabled = true,
        text_format = "  %s" -- %s will be replaced with the symlink target's path.
      }
    }
  }
}