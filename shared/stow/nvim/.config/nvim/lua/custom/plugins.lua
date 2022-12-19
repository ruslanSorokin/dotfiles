local plugins = {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				opts = {
					history = true,
					updateevents = "TextChanged,TextChangedI",
				},
				config = function(_, opts)
					require("plugins.configs.others").luasnip(opts)
				end,
			},
			{
				"windwp/nvim-autopairs",
				opts = {
					fast_wrap = {},
					disable_filetype = { "TelescopePrompt", "vim" },
				},
				config = function(_, opts)
					require("nvim-autopairs").setup(opts)

					-- setup cmp for autopairs
					local cmp_autopairs = require("nvim-autopairs.completion.cmp")
					require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
				end,
			},
			{
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
		},
		opts = function()
			return require("custom.configs.cmp")
		end,
		config = function(_, opts)
			require("cmp").setup(opts)
			require("custom.configs.cmp")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeOpen" },
		opts = function()
			return require("custom.configs.nvim-tree")
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("custom.configs.web-devicons")
		end,
	},
	{
		"nvim-pack/nvim-spectre",
		cmd = "Spectre",
		opts = { is_block_ui_break = true },
	},
	{ "tpope/vim-fugitive", lazy = false },
	{ "mbbill/undotree" },
	{ "mg979/vim-visual-multi", lazy = false },
	{ "chaoren/vim-wordmotion", lazy = false },
	{ "tpope/vim-dadbod" },
	{ "kristijanhusak/vim-dadbod-ui" },
	{ "kristijanhusak/vim-dadbod-completion" },
	{ "stevearc/dressing.nvim", lazy = false },
	{ "tpope/vim-vinegar", lazy = false },
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"actionlint",
				"buf",
				"buf-language-server",
				"commitlint",
				"cspell",
				"docker-compose-language-service",
				"gitlint",
				"gopls",
				"graphql-language-service-cli",
				"lua-language-server",
				"luacheck",
				"luaformatter",
				"marksman",
				"prettier",
				"prettierd",
				"sqlls",
				"typos",
				"yaml-language-server",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		ft = { "go", "lua", "sql" },
		opts = function()
			return require("custom.configs.null-ls")
		end,
	},
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		config = function(_, opts)
			require("gopher").setup(opts)
			require("core.utils").load_mappings("gopher")
		end,
		build = function()
			vim.cmd([[silent! GoInstallDeps]])
		end,
	},
}
return plugins
