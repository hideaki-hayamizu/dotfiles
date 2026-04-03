local tab_width = 4

local function determine_shell()
  if vim.fn.has('win32') == 1 or vim.fn.has('win64') then
    return 'pwsh.exe' -- 'powershell.exe'
  elseif vim.fn.has('mac') == 1 then
    return 'zsh'
  elseif vim.fn.has('linux') == 1 or vim.fn.has('wsl') then
    return 'bash'
  end
end

local opts = {
  number = true,
  relativenumber = false,
  cursorline = true,
  cursorcolumn = false,
  mouse = 'a', --enable mouse
  clipboard = 'unnamedplus',
  termguicolors = true, -- enable 24-bit color
  splitright = true,
  splitbelow = true,
  splitkeep = 'cursor',
  scrolloff = 0,
  list = true,
  listchars = {
    tab = ">>",
    trail = ".",
    extends = "+",
    precedes = "-",
  },
  title = true,
  laststatus = 3, -- global status line
  ruler = false,
  cmdheight = 1,
  encoding = "utf-8",
  fileencoding = "utf-8",
  shell = determine_shell(),
  backspace = { "indent", "eol", "start" },
  backupdir = vim.fn.expand(vim.fn.stdpath("cache") .. "/.vim/backup"),
  backup = false,
  writebackup = true,
  swapfile = false,
  undofile = false,
  autoread = true,
  hidden = true,
  wrap = false,
  breakindent = true,
  showmatch = true,
  showmode = false,
  showcmd = false,
  tabstop = tab_width,
  softtabstop = tab_width,
  shiftwidth = tab_width,
  expandtab = true,
  smarttab = true,
  autoindent = true,
  smartindent = true,
  ignorecase = true,
  smartcase = true,
  incsearch = true,
  hlsearch = true,
  wrapscan = true,
  inccommand = 'split',
  ttyfast = true,
  smoothscroll = true,
  pumblend = 10,
  foldmethod = "indent",
  foldlevel = 99,
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.shortmess:append("I")
for k, v in pairs(opts) do
  vim.opt[k] = v
end