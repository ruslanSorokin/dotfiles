local w = require("wezterm")
local u = require("utils")

local font_size
local font

font_size = 18

local JetBrainsMonoFont = {
	family = "JetBrainsMono Nerd Font Propo",
	-- See: https://github.com/JetBrains/JetBrainsMono/wiki/OpenType-features
	harfbuzz_features = {
		"calt=1",
		"ss19",
		"cv07",
		"cv14",
		"cv18",
		"cv19",
		"cv20",
		"cv99",
		"ss06",
		"zero",
	},
}

if u.is_darwin() then
	font_size = 18
	font = w.font_with_fallback({
		JetBrainsMonoFont,
		"MesloLGL Nerd Font",
		"DroidSansMono Nerd Font",
	})
end

if u.is_linux() then
	font_size = 15
	font = w.font_with_fallback({
		JetBrainsMonoFont,
		"MesloLGL Nerd Font",
		"DroidSansMono Nerd Font",
	})
end

if u.is_windows() then
	font_size = 15
	font = w.font_with_fallback({
		JetBrainsMonoFont,
		"MesloLGL Nerd Font",
		"DroidSansMono Nerd Font",
	})
end

local M = {}

M.apply = function(config)
	config.font_size = font_size
	config.font = font
end

return M
