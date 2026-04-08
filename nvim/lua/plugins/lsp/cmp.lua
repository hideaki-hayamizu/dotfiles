return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  init = function()
    local map = function (lhs, rhs)
      vim.keymap.set('i', lhs, rhs)
    end

    -- disable
    map('<C-u>', '<Nop>')
  end,
  opts = {
    keymap = {
      preset = 'none',
      ['<Tab>'] = { 'select_and_accept', 'fallback' },

      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },

      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-S-d>'] = { 'scroll_signature_down', 'fallback' },
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-S-u>'] = { 'scroll_signature_up', 'fallback' },

      ['<C-e>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      ['<Esc>'] = { 'cancel', 'fallback' },
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
        auto_show = true,
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
    signature = {
      enabled = true,
      window = { border = 'single' }
    },
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