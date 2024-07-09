require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<C-u>", "_dP")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

map("n", "<leader>u", "<cmd> UndotreeToggle <CR>")
map("n", "<leader>gs", "<cmd> Git <CR>")
map("n", "<leader>n", "<cmd> NullLsInfo <CR>")
map("n", "<leader>nl", "<cmd> NullLsLog <CR>")
map("n", "<leader>m", "<cmd> Mason <CR>")
map("n", "<leader>l", "<cmd> Lazy <CR>")
map("n", "<leader>e", "<cmd> NvimTreeFocus <CR>")

map("n", "<C-l>", function()
  require("nvchad.tabufline").next()
end)
map("n", "<C-h>", function()
  require("nvchad.tabufline").prev()
end)
map("n", "<C-x>", function()
  require("nvchad.tabufline").close_buffer()
end)

map("n", "<C-e>", "<cmd> NvimTreeOpen <CR>")
map("n", "<C-e>", "<cmd> NvimTreeToggle  <CR>")
map("n", "<leader-e>", "<cmd> NvimTreeFocus <CR>")

map("n", "<leader>gsj", "<cmd>  GoTagAdd json  <CR>")
map("n", "<leader>gsy", "<cmd>  GoTagAdd yaml  <CR>")

map("i", "jk", "<ESC>")
map("x", "<leader>p", "_dP")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
