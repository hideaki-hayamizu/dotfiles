-- swap
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", ":", ";")

-- jk
vim.keymap.set({ "n", "x" }, "j", function ()
  if vim.v.count > 0 then
    return "m'" .. vim.v.count .. "j"
  else
    return "gj"
  end
end, { expr = true })
vim.keymap.set({ "n", "x" }, "k", function ()
  if vim.v.count > 0 then
    return "m'" .. vim.v.count .. "k"
  else
    return "gk"
  end
end, { expr = true })

-- split window
vim.keymap.set("n", "ss", "<cmd>split<CR>", { desc = "Split the window" })
vim.keymap.set("n", "sv", "<cmd>vsplit<CR>", { desc = "Vertical split the window" })

-- move window
vim.keymap.set("n", "sh", "<C-w>h", { desc = "Move the window left" })
vim.keymap.set("n", "sj", "<C-w>j", { desc = "Move the window down" })
vim.keymap.set("n", "sk", "<C-w>k", { desc = "Move the window up" })
vim.keymap.set("n", "sl", "<C-w>l", { desc = "Move the window right" })

-- resize window
vim.keymap.set("n", "<C-h>", "<C-w><", { desc = "Resize the window" })
vim.keymap.set("n", "<C-j>", "<C-w>-", { desc = "Resize the window" })
vim.keymap.set("n", "<C-k>", "<C-w>+", { desc = "Resize the window" })
vim.keymap.set("n", "<C-l>", "<C-w>>", { desc = "Resize the window" })

-- tab
vim.keymap.set("n", "tt", "<cmd>tabe .<CR>", { desc = "Create a new tab" })
vim.keymap.set("n", "tw", "<cmd>tabclose<CR>", { desc = "Close the tab" })
vim.keymap.set("n", "t]", "<cmd>tabnext<CR>", { desc = "Tab next" })
vim.keymap.set("n", "t[", "<cmd>tabprevious<CR>", { desc = "Tab prev" })

-- buffer
vim.keymap.set("n", "bw", "<cmd>bdelete<CR>", { desc = "Buffer delete" })
vim.keymap.set("n", "b]", "<cmd>bnext<CR>", { desc = "Buffer next" })
vim.keymap.set("n", "b[", "<cmd>bprevious<CR>", { desc = "Buffer prev" })

-- bash shortcut keys
vim.keymap.set("c", "<C-a>", "<Home>", { silent = false })
vim.keymap.set("c", "<C-e>", "<End>", { silent = false })
vim.keymap.set("c", "<C-d>", "<DEL>", { silent = false })
vim.keymap.set("c", "<C-b>", "<left>", { silent = false })
vim.keymap.set("c", "<C-f>", "<right>", { silent = false })

-- utils
vim.keymap.set("i", "jj", "<Esc>") -- go to normal mode
vim.keymap.set("n", "U", "<C-r>") -- redo
vim.keymap.set("x", "y", "mzy`z") -- yank
vim.keymap.set("x", "p", "P") -- paste
vim.keymap.set("x", "<", "<gv") -- indent
vim.keymap.set("x", ">", ">gv") -- indent
vim.keymap.set("t", "<Esc>", "[[<C-\\><C-n>]]") -- go to normal mode
vim.keymap.set({ "n", "v" }, "x", '"_x') -- use unnamed register
vim.keymap.set({ "n", "v" }, "X", '"_d$') -- use unnamed register
vim.keymap.set("n", "+", "<C-a>") -- inclement
vim.keymap.set("n", "-", "<C-x>") -- decrement
vim.keymap.set("n", "<C-a>", "gg<S-v>G") -- select all
vim.keymap.set("n", "<leader>s", ":%s//g<Left><Left>", { desc = "Replace all" }) --replace all
