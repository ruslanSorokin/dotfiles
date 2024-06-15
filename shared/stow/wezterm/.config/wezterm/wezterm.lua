local w = require("wezterm")
local u = require("utils")

local config = {}

if w.config_builder then
	config = w.config_builder()
end

require("keys").apply(config)
require("font").apply(config)

config.color_scheme = "Monokai Pro (Gogh)"
-- config.color_scheme = 'Catppuccin Frappe'
-- config.color_scheme = 'Darcula (base16)'
-- config.color_scheme = 'Tokyo Night Storm (Gogh)'

config.default_cursor_style = "SteadyUnderline"
config.tab_bar_at_bottom = true

config.cursor_blink_rate = 600
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_ease_in = "Constant"

config.initial_rows = 24
config.initial_cols = 108

config.window_close_confirmation = "NeverPrompt"
config.audible_bell = "Disabled"

config.window_background_opacity = 1
config.macos_window_background_blur = 10
config.native_macos_fullscreen_mode = true
config.enable_scroll_bar = false

if u.is_windows() or u.is_linux() then
	config.max_fps = 144
elseif u.is_darwin() then
	config.max_fps = 60
	config.dpi = 144
end

if u.is_windows() then
	config.wsl_domains = {
		{
			name = "WSL:Ubuntu",
			distribution = "Ubuntu",
			username = "ruslan",
			default_cwd = "/home/ruslan",
			default_prog = {
				"/usr/bin/zsh",
				"-l",
				"-c",
				"fish -l",
				-- "fish -l -c 'fish'",
			},
		},
	}
	config.default_domain = "WSL:Ubuntu"
elseif u.is_darwin() then
	config.default_prog = {
		"/bin/zsh",
		"-l",
		"-c",
		"fish -l",
	}
elseif u.is_linux() then
	config.default_prog = {
		"/usr/bin/zsh",
		"-l",
		"-c",
		"fish -l",
	}
end

return config
