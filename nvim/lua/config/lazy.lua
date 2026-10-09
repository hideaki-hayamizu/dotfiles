-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")

-- Load config files
require("config.options")
require("config.mappings")
require("config.autocmds")

-- Setup lazy.nvim
require("lazy").setup({
  defaults = {
    lazy = false, -- should plugins be lazy-loaded?
  },
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "habamax" } },
  rocks = {
    enabled = false,
    hererocks = false, -- always use luarocks
  },
  ui = {
    border = "rounded",
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "netrwPlugin",
        "tutor",
      }
    },
  }
})