local M = {}

M.general = {
	x = { ["<leader>p"] = { '"_dP' } },
	n = {
		["<C-l>"] = {
			function()
				require("nvchad.tabufline").tabuflineNext()
			end,
			"Goto next buffer",
		},

		["<C-h>"] = {
			function()
				require("nvchad.tabufline").tabuflinePrev()
			end,
			"Goto prev buffer",
		},

		["<C-u>"] = { "<C-u>zz" },
		["<C-d>"] = { "<C-d>zz" },

		["<leader>u"] = { "<cmd> UndotreeToggle <CR>" },
		["<leader>gs"] = { "<cmd> Git <CR>" },
		["<leader>n"] = { "<cmd> NullLsInfo <CR>" },
		["<leader>nl"] = { "<cmd> NullLsLog <CR>" },
		["<leader>m"] = { "<cmd> Mason <CR>" },
		["<leader>l"] = { "<cmd> Lazy <CR>" },
		["<leader>e"] = { "<cmd> NvimTreeFocus <CR>" }, -- FIXME
		["<C-x>"] = {
			function()
				require("nvchad.tabufline").close_buffer()
			end,
			"Close buffer",
		},
	},
}

M.nvimtree = {
	plugin = true,

	n = {
		["<C-e>"] = { "<cmd> NvimTreeOpen <CR>", "Open nvimtree" },
		-- ["<C-e>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
		["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
	},
}

M.gopher = {
	plugin = true,
	n = {
		["<leader>gsj"] = { "<cmd>  GoTagAdd json  <CR>", "Add json struct tags" },
		["<leader>gsy"] = { "<cmd>  GoTagAdd yaml  <CR>", "Add yaml struct tags" },
	},
}

return M
