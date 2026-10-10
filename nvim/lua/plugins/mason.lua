return {
  {
    "mason-org/mason.nvim",
    version = "^2",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = ""
        },
        keymaps = {
          uninstall_package = "X",
        }
      }
    }
  },
  {
    "mason-org/mason-lspconfig.nvim",
    version = "^2",
    dependencies = {
      "mason-org/mason.nvim",
      {
        "neovim/nvim-lspconfig",
        version = "^2"
      }
    },
    opts = {
      ensure_installed = {
        "asm_lsp", "autotools_ls", "bashls", "clangd", "cssls", "dockerls", "glsl_analyzer", "html",
        "jdtls", "jsonls", "lua_ls", "marksman", "neocmake", "powershell_es", "pyright",
        "rust_analyzer", "sqlls", "ts_ls", "tombi", "vimls", "wgsl_analyzer", "yamlls"
      },
      automatic_enable = {
        exclude = {
          "jdtls",
        }
      }
    }
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      {
        "nvimtools/none-ls.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim"
        },
      }
    },
    config = function()
      local null_ls = require("null-ls")

      require("mason-null-ls").setup({
        ensure_installed = {
          -- linter
          "checkmake", "checkstyle", "hadolint", "markdownlint", "vint",
          "stylelint", "ruff", "sqlfluff", "yamllint", "shellcheck",
          -- formatter
          "shfmt", "stylua", "prettier", "clang_format", "gersemi", "google_java_format",
          -- misc
          "codespell",
        },
        handlers = {
          function(source_name, methods)
            require("mason-null-ls.automatic_setup")(source_name, methods)
          end,
          -- servers
          stylua = function(source_name, methods)
            null_ls.register(null_ls.builtins.formatting.stylua.with({
              extra_args = {
                "--indent-type", "Spaces",
                "--indent-width", "2",
              },
            }))
          end,
          shellcheck = function() end,
        }
      })

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.rustfmt,
        },
      })

      -- format
      local function format(bufnr)
        vim.lsp.buf.format({
          bufnr = bufnr,
          timeout_ms = 15000,
          filter = function(client)
            return client.name == "null-ls"
          end,
        })
      end

      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        format(vim.api.nvim_get_current_buf())
      end, { desc = "Format" })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
        callback = function(args)
          if vim.bo[args.buf].buftype ~= "" then return end
          format(args.buf)
        end,
      })
    end
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap"
    },
    opts = {
      ensure_installed = {
        "python", "bash", "javadbg", "codelldb"
      },
      automatic_installation = { exclude = {} },
      handlers = {},
    }
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      {
        "mfussenegger/nvim-dap",
        lazy = false,
        keys = {
          {
            "<leader>dtb",
            "<cmd>DapToggleBreakpoint<CR>",
            desc = "DAP: Setting breakpoints",
          },
          {
            "<leader>dc",
            "<cmd>DapContinue<CR>",
            desc = "DAP: Launching debug sessions",
          },
          {
            "<leader>dso",
            "<cmd>DapStepOver<CR>",
            desc = "DAP: Stepping through code ",
          },
          {
            "<leader>dsi",
            "<cmd>DapStepInto<CR>",
            desc = "DAP: Stepping through code ",
          },
          {
            "<leader>dsu",
            "<cmd>DapStepOut<CR>",
            desc = "DAP: Step out"
          },
          {
            "<leader>dq",
            "<cmd>DapTerminate<CR>",
            desc = "DAP: Terminate" 
          },
        }
      },
      "nvim-neotest/nvim-nio"
    },
    lazy = false,
    keys = {
      {
        "<leader>dut",
        function() require("dapui").toggle() end,
        desc = "DAP UI toggle",
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter"
    },
    opts = {}
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {}
  }
}