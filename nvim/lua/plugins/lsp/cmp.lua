return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  opts = {
    keymap = {
      preset = 'none',
      ['<Tab>'] = { 'show_and_insert_or_accept_single', 'select_next' },
      ['<S-Tab>'] = { 'show_and_insert_or_accept_single', 'select_prev' },

      ['<C-space>'] = { 'show', 'fallback' },

      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<Right>'] = { 'select_next', 'fallback' },
      ['<Left>'] = { 'select_prev', 'fallback' },

      ['<C-y>'] = { 'select_and_accept', 'fallback' },
      ['<C-e>'] = { 'cancel', 'fallback' },
    },
    appearance = {
      nerd_font_variant = 'mono'
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = false,
          kind_resolution = {
            blocked_filetypes = {}
          },
          semantic_token_resolution = {
            blocked_filetypes = {}
          }
        },
      },
      menu = { border = 'single' },
      documentation = {
        auto_show = false,
        window = { border = 'single' }
      },
      ghost_text = { enabled = true },
      trigger = {
        show_on_keyword = true,
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        cmdline = {
          enabled = function()
            return vim.fn.getcmdtype() ~= ':' or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
          end
        }
      }
    },
    signature = { window = { border = 'single' } },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts = {
        'exact',
        'score',
        'sort_text',
        'label'
      }
    },
    cmdline = {
      keymap = {
        ['<Tab>'] = { 'show', 'accept' },
      },
      completion = {
        ghost_text = { enabled = true },
        menu = { auto_show = true },
      }
    }
  },
  opts_extend = { "sources.default" }
}