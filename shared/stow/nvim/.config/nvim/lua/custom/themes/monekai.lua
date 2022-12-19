local M = {}

M.base_30 = {
	white = "#fdf9f3",
	darker_black = "#221f22", -- <-- explorer bg
	black = "#403e41", -- <-- completions bg + active tab == base_16.base00
	black2 = "#363537", -- <-- active file in explorer + all unactive tabs and space at the top
	one_bg = "#403e41", -- <-- tabs in Mason menu
	one_bg2 = "#403e41", -- <-- selected text
	one_bg3 = "#464741", -- <-- don't know
	grey = "#575558", -- <-- line numbers
	grey_fg = "#555650", -- <-- comments
	grey_fg2 = "#5D5E58", -- <-- don't know
	light_grey = "#64655F", -- <-- filenames in the tab section
	red = "#ff6188", -- <--
	baby_pink = "#f98385", -- <--
	pink = "#ff6188", -- <--
	line = "#75715e", -- <-- for lines like vertsplit
	green = "#a9dc76", -- <--
	vibrant_green = "#a9dc76", -- <--
	nord_blue = "#81A1C1", -- <--
	blue = "#51afef", -- <--
	yellow = "#ffd866", -- <--
	sun = "#ffd866", -- <--
	purple = "#c885d7", -- <--
	dark_purple = "#b26fc1", -- <--
	teal = "#34bfd0", -- <--
	orange = "#ffb86c", -- <--
	cyan = "#41afef", -- <--
	statusline_bg = "#221f22", -- <--
	lightbg = "#403e41", -- <--
	pmenu_bg = "#a9dc76", -- <--
	folder_bg = "#90a4ae", -- <--
}

M.base_16 = {
	base00 = "#363537",
	base01 = "#75715e",
	base02 = "#90a4ae",
	base03 = "#75715e",
	base04 = "#a59f85",
	base05 = "#fdf9f3",
	base06 = "#fdf9f3",
	base07 = "#fdf9f3",
	base08 = "#fc9867",
	base09 = "#ae81ff",
	base0A = "#ffd866",
	base0B = "#f4bf75",
	base0C = "#aa9df1",
	base0D = "#66d9ef",
	base0E = "#ff6188",
	base0F = "#aa9df1",
}

M.type = "dark"

return M
