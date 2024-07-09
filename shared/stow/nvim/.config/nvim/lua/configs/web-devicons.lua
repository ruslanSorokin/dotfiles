local web_devicons = require("nvim-web-devicons")

local go_mod_color = "#ec407a"
local go_color = "#00acd7"

web_devicons.setup({
	-- your personnal icons can go here (to override)
	-- you can specify color or cterm_color instead of specifying both of them
	-- DevIcon will be appended to `name`
	override = {
		zsh = {
			icon = "",
			color = "#428850",
			cterm_color = "65",
			name = "zsh",
		},
	},
	-- globally enable different highlight colors per icon (default to true)
	-- if set to false all icons will have the default icon's color
	color_icons = true,
	-- globally enable default icons (default to false)
	-- will get overriden by `get_icons` option
	default = true,
	-- globally enable "strict" selection of icons - icon will be looked up in
	-- different tables, first by filename, and if not found by extension; this
	-- prevents cases when file doesn't have any extension but still gets some icon
	-- because its name happened to match some extension (default to false)
	strict = true,
	-- same as `override` but specifically for overrides by filename
	-- takes effect when `strict` is true
	--

	override_by_filename = {
		[".gitignore"] = { icon = "", color = "#f1502f", name = "gitignore" },
		["go.mod"] = { icon = "󰟓", color = go_mod_color, name = "go_module" },
		["go.sum"] = { icon = "󰌾", color = go_mod_color, name = "go_lockfile" },
		["go.work"] = { icon = "󰟓", color = go_mod_color, name = "go_work" },
		["go.work.sum"] = {
			icon = "󰌾",
			color = go_mod_color,
			name = "go_work_lockfile",
		},
	},
	-- same as `override` but specifically for overrides by extension
	-- takes effect when `strict` is true
	override_by_extension = {
		["go"] = { icon = "󰟓", color = go_color, name = "go" },
		["yaml"] = { icon = "󰧮", color = "#ff5252", name = "yaml" },
		["toml"] = { icon = "󰧮", color = "#ffffff", name = "toml" },
	},
})
