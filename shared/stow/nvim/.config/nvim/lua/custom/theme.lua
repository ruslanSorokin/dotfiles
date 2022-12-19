local M = {}

local monekai = "custom.themes.monekai"
local catppuccin = "custom.themes.catppuccin"

M = {
	theme = "monekai",
	changed_themes = { monekai = monekai, catppuccin = catppuccin },
	statusline = {
		theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
		separator_style = "arrow", -- default/round/block/arrow separators work only for default statusline theme
		-- round and block will work for minimal theme only
		overriden_modules = nil,
	},
}

return M
