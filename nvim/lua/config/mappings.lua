-- set leader
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

-- nop
vim.keymap.set({ 'n', 'v' }, 's', '<Nop>')
vim.keymap.set({ 'n', 'v' }, 'S', '<Nop>')

-- swap
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', ':', ';')

-- jj -> normal mode
vim.keymap.set('i', 'jj', '<Esc>')

-- use black hole register
vim.keymap.set({ 'n', 'v' }, 'x', '"_x')
vim.keymap.set({ 'n', 'v' }, 'X', '"_d$')

-- increment, decrement
vim.keymap.set('n', '+', '<C-a>')
vim.keymap.set('n', '-', '<C-x>')

-- select all
vim.keymap.set('n', '<C-a>', 'gg<S-v>G')

-- split window
vim.keymap.set('n', 'ss', '<cmd>split<CR>')
vim.keymap.set('n', 'sv', '<cmd>vsplit<CR>')

-- move window
vim.keymap.set('n', 'sh', '<C-w>h')
vim.keymap.set('n', 'sj', '<C-w>j')
vim.keymap.set('n', 'sk', '<C-w>k')
vim.keymap.set('n', 'sl', '<C-w>l')

-- resize window
vim.keymap.set('n', 'srh', '<C-w>>')
vim.keymap.set('n', 'srj', '<C-w>+')
vim.keymap.set('n', 'srk', '<C-w>-')
vim.keymap.set('n', 'srl', '<C-w><')

-- tab
vim.keymap.set('n', 'tt', '<cmd>tabe<CR>') -- disable netrw at your init.lua
vim.keymap.set('n', 'tq', '<cmd>tabclose<CR>')
vim.keymap.set('n', 'tn', '<cmd>tabnext<CR>')
vim.keymap.set('n', 'tp', '<cmd>tabprevious<CR>')

-- buffer
vim.keymap.set("n", "br", "<cmd>enew<CR>")
vim.keymap.set("n", "bq", "<cmd>BufferClose<CR>")
vim.keymap.set("n", "bn", "<cmd>bnext<CR>")
vim.keymap.set("n", "bp", "<cmd>bprevious<CR>")
vim.keymap.set("n", "bi", "<cmd>>BufferPin<CR>")

-- terminal
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- custom
vim.keymap.set('n', 'U', '<C-r>') -- redo
vim.keymap.set("x", "y", "mzy`z") -- keep cursor position after yank in visual mode
vim.keymap.set("x", "<", "<gv") -- keep cursor position in visual mode
vim.keymap.set("x", ">", ">gv")
vim.keymap.set('x', '<tab>', '>gv', { noremap = false })
vim.keymap.set('x', '<S-tab>', '<gv', { noremap = false })