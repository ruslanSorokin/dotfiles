require("full-border"):setup()
require("yatline"):setup({
	section_separator = { open = "", close = "" },
	part_separator = { open = "", close = "" },
	inverse_separator = { open = "", close = "" },

	style_a = {
		fg = "black",
		bg_mode = {
			normal = "#babbf1", -- Lavender (Frappé)
			select = "#f2cdcd", -- Pink (Frappé)
			un_set = "#eebebe", -- Red (Frappé)
		},
	},
	style_b = { bg = "#575268", fg = "#babbf1" }, -- Surface0 and Lavender (Frappé)
	style_c = { bg = "#303446", fg = "#ca9ee6" }, -- Base and Mauve (Frappé)

	permissions_t_fg = "#a6d189", -- Green (Frappé)
	permissions_r_fg = "#f4b8e4", -- Yellow (Frappé)
	permissions_w_fg = "#eebebe", -- Red (Frappé)
	permissions_x_fg = "#8caaee", -- Blue (Frappé)
	permissions_s_fg = "#626880", -- Overlay0 (Frappé)

	tab_width = 20,
	tab_use_inverse = false,

	selected = { icon = "󰻭", fg = "#f4b8e4" }, -- Yellow (Frappé)
	copied = { icon = "", fg = "#a6d189" }, -- Green (Frappé)
	cut = { icon = "", fg = "#eebebe" }, -- Red (Frappé)

	total = { icon = "󰮍", fg = "#f4b8e4" }, -- Yellow (Frappé)
	succ = { icon = "", fg = "#a6d189" }, -- Green (Frappé)
	fail = { icon = "", fg = "#eebebe" }, -- Red (Frappé)
	found = { icon = "󰮕", fg = "#8caaee" }, -- Blue (Frappé)
	processed = { icon = "󰐍", fg = "#a6d189" }, -- Green (Frappé)

	show_background = true,

	display_header_line = true,
	display_status_line = true,

	header_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_path", params = { "left" } },
			},
			section_b = {},
			section_c = {},
		},
		right = {
			section_a = {
				{ type = "line", custom = false, name = "tabs", params = { "right" } },
			},
			section_b = {},
			section_c = {},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {
				{ type = "string", custom = false, name = "hovered_size" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_name" },
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "cursor_position" },
			},
			section_b = {
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
	},
})
require("relative-motions"):setup({ show_numbers = "relative_absolute" })

require("git"):setup()
-- require("copy-file-contents"):setup({
-- 	clipboard_cmd = "pbcopy",
-- 	append_char = "\n",
-- 	notification = true,
-- })
require("copy-content"):setup({
	clipboard_cmd = "pbcopy",
	append_char = "\n",
	notification = true,
})

-- show symlink path
function Status:name()
	local h = self._tab.current.hovered
	if not h then
		return ui.Line({})
	end

	local linked = ""
	if h.link_to ~= nil then
		linked = " -> " .. tostring(h.link_to)
	end
	return ui.Line(" " .. h.name .. linked)
end
