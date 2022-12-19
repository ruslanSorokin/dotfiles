---@type ChadrcConfig
local M = {}

M.ui = require("custom.theme")
M.plugins = "custom.plugins"

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

M.mappings = require("custom.mappings")

vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undotree"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.api.nvim_set_hl(0, "VM_Mono", {
	bg = vim.api.nvim_get_color_by_name("Grey"),
	fg = vim.api.nvim_get_color_by_name("Black"),
})

return M
