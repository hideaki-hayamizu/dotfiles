local tab_width = 4

function Foldtext()
  local line = vim.fn.getline(vim.v.foldstart)
  local count = vim.v.foldend - vim.v.foldstart + 1
  return string.format("%s (%d lines folded)", line, count)
end

local function set_shell()
  if vim.fn.has("win64") == 1 then
    return "pwsh.exe"
  elseif vim.fn.has("mac") == 1 then
    return "zsh"
  else
    return "bash"
  end
end

-- local function paste()
--   return {
--     vim.fn.split(vim.fn.getreg(""), "\n"),
--     vim.fn.getregtype(""),
--   }
-- end

local global = {
  mapleader = "\\",
  loaded_netrw = 1,
  loaded_netrwPlugin = 1,
  python3_host_prog = vim.env.HOME .. "/.venvs/nvim/Scripts/python.exe",
  node_host_prog = vim.trim(vim.fn.system({ "mise", "where", "node" })) .. "/node_modules/neovim/bin/cli.js",
  -- clipboard = {
  --   name = "OSC 52",
  --   copy = {
  --     ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
  --     ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  --   },
  --   paste = {
  --     ["+"] = paste,
  --     ["*"] = paste,
  --   },
  -- }
}

local opts = {
  clipboard = "unnamedplus",
  mouse = "a",
  shell = set_shell(),
  confirm = true,
  undolevels = 1000,
  history = 1000,
  backup = false,
  writebackup = false,
  swapfile = false,
  undofile = true,
  backupext = ".bak",
  backupdir = vim.fn.expand(vim.fn.stdpath("cache") .. "/.vim_backup"),
  directory = vim.fn.expand(vim.fn.stdpath("cache") .. "/.vim_swap"),
  undodir = vim.fn.expand(vim.fn.stdpath("cache") .. "/.vim_undo"),
  autoread = true,
  encoding = "utf-8",
  fileencoding = "utf-8",
  hidden = true,
  laststatus = 3,
  cmdheight = 0,
  scrolloff = 2,
  title = true,
  titlestring = "nvim",
  showmode = false,
  showcmd = false,
  showtabline = 2,
  cursorline = false,
  virtualedit = "onemore",
  visualbell = true,
  errorbells = false,
  wrap = false,
  number = true,
  relativenumber = false,
  autoindent = true,
  smartindent = true,
  breakindent = true,
  expandtab = true,
  smarttab = true,
  tabstop = tab_width,
  shiftwidth = tab_width,
  softtabstop = tab_width,
  foldmethod = "indent",
  foldtext = "v:lua.Foldtext()",
  foldlevel = 99,
  foldcolumn = "1",
  fillchars = {
    eob = " ",
    fold = " ",
    foldclose = "",
    foldopen = "",
    foldsep = " ",
    foldinner = " ",
  },
  list = true,
  listchars = {
    tab = " ",
    trail = "_",
    nbsp = "+",
    extends = "",
    precedes = "",
  },
  backspace = { "start", "eol", "indent" },
  termguicolors = true,
  signcolumn = "yes",
  showmatch = true,
  incsearch = true,
  hlsearch = true,
  wrapscan = true,
  inccommand = "split",
  ignorecase = true,
  smartcase = true,
  splitbelow = true,
  splitright = true,
  splitkeep = "screen",
  wildmode = { list = "longest" },
}

for k, v in pairs(global) do
  vim.g[k] = v
end

for _, dir in ipairs({ opts.backupdir, opts.directory, opts.undodir }) do
  vim.fn.mkdir(dir, "p")
end

for k, v in pairs(opts) do
  vim.opt[k] = v
end

vim.opt.shortmess:append("I")
vim.opt.guicursor = "a:ver1,a:blinkwait200-blinkoff400-blinkon400"
