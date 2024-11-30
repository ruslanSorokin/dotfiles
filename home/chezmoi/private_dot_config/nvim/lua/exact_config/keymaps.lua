-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
-- ^r = insert text from a register
-- ^a = insert text from register '.'
-- ^p = completion menu
-- ^x = special "completion mode" submode of insert
-- |-- ^] = tag
-- |-- ^p = pull from previous context
-- |-- ^n = pull from next context
-- |-- ^f = file completion
-- |-- ^l = line
-- |-- ^o = omnicompletion

local map = vim.keymap.set
local unmap = vim.keymap.del

map("n", "<Leader>xQ", vim.cmd.copen, { desc = "Quickfix list" })
map("n", "<Leader>xL", vim.cmd.lopen, { desc = "Location list" })

map("n", "dD", "ddi<CR><ESC>k", { desc = "Clear line of anything but '\n'" })

map("n", "[Q", vim.cmd.cfirst, { desc = "First Quickfix" })
map("n", "]Q", vim.cmd.clast, { desc = "Last Quickfix" })

-- move selected text using <S-hjkl>
unmap("n", "<A-j>")
unmap("n", "<A-k>")
unmap("i", "<A-j>")
unmap("i", "<A-k>")
unmap("v", "<A-j>")
unmap("v", "<A-k>")

map("n", "<leader>L", "<CMD>LazyHealth<CR>", { desc = "Lazy Health" })
Snacks.toggle.zoom():map("<leader>wm"):map("<C-w>m")

map({ "n", "v", "x" }, "<C-N>", "<C-I>", { desc = "Jumplist: Next location" })
map({ "n", "v", "x" }, "<C-P>", "<C-O>", { desc = "Jumplist: Previous location" })

map("n", "yyp", "mmyyp`mj", { desc = "Duplicate line and keep cursor" })

map("n", "dm", "<CMD>delmarks!<CR>", { desc = "Delete all marks" })

map(
  "n",
  "]<Space>",
  [[:<C-u>put =repeat(nr2char(10),v:count)<BAR>execute "'[-1"<CR>]],
  { noremap = true, silent = true, desc = "Insert blank line up" }
)

map(
  "n",
  "[<Space>",
  [[:<C-u>put!=repeat(nr2char(10),v:count)<BAR>execute "']+1"<CR>]],
  { noremap = true, silent = true, desc = "Insert blank line down" }
)

map("v", "gs<Space>", "dO<CR><ESC>kp", { desc = "Surround the selection with '\n'" })
map("n", "gs<Space>", "<S-V>dO<CR><ESC>kp", { desc = "Surround line with '\n'" })
