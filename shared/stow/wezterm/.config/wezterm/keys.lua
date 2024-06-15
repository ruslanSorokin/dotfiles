local w = require("wezterm")
local u = require("utils")
local wa = w.action

local leader = {
	key = "Space",
	mods = "CTRL",
	timeout_milliseconds = math.maxinteger,
}

local keys = {}

local map = u.new_mapper(keys)
---comment
---@param a { act: any, darwin_key: string, darwin_modes: string|table, linux_key: string, linux_modes: string|table, windows_key: string, windows_modes: string|table }
local xplatform_map = function(a)
	local os_pairs = {
		{ "darwin",  u.is_darwin,  a.darwin_key,  a.darwin_modes },
		{ "linux",   u.is_linux,   a.linux_key,   a.linux_modes },
		{ "windows", u.is_windows, a.windows_key, a.windows_modes },
	}

	for _, os_pair in ipairs(os_pairs) do
		local os = os_pair[1]
		local is_os = os_pair[2]

		local k = os_pair[3]
		local m = os_pair[4]

		if is_os() then
			if k and m then
				map(k, m, a.act)
			elseif k or m then
				w.log_error(
					string.format("one of the variables for platform %s is missing: [key: %s, modes: %s]", os, k, m)
				)
			end
		end
	end
end


-- ------------------------- Navigation between tabs ------------------------ --
for i = 1, 9 do
	map(tostring(i), { "LEADER", "SUPER" }, wa.ActivateTab(i - 1))
end
map("0", { "LEADER", "SUPER" }, wa.ActivateTab(-1))

map("h", { "LEADER", "SUPER" }, wa.ActivatePaneDirection("Left"))
map("j", { "LEADER", "SUPER" }, wa.ActivatePaneDirection("Down"))
map("k", { "LEADER", "SUPER" }, wa.ActivatePaneDirection("Up"))
map("l", { "LEADER", "SUPER" }, wa.ActivatePaneDirection("Right"))

-- --------------------------------- Resize --------------------------------- --
map("h", "LEADER|SHIFT", wa.AdjustPaneSize({ "Left", 5 }))
map("j", "LEADER|SHIFT", wa.AdjustPaneSize({ "Down", 5 }))
map("k", "LEADER|SHIFT", wa.AdjustPaneSize({ "Up", 5 }))
map("l", "LEADER|SHIFT", wa.AdjustPaneSize({ "Right", 5 }))

-- ------------------------------ Spawn & Close ----------------------------- --
map("n", "SHIFT|CTRL", wa.SpawnTab("CurrentPaneDomain"))

map("|", "SHIFT|LEADER", wa.SplitHorizontal({ domain = "CurrentPaneDomain" }))
map("_", "SHIFT|LEADER", wa.SplitVertical({ domain = "CurrentPaneDomain" }))

map("x", "LEADER", wa.CloseCurrentPane({ confirm = false }))
map("x", "SHIFT|CTRL", wa.CloseCurrentTab({ confirm = false }))

-- ---------------------------------- Zoom ---------------------------------- --
map("z", "LEADER|CTRL", wa.TogglePaneZoomState)
map("s", "LEADER|CTRL", u.toggleTabBar)

-- ------------------------------ Copy & Paste ------------------------------ --
map("v", "LEADER", wa.ActivateCopyMode)
map("c", { "SHIFT|CTRL" }, wa.CopyTo("Clipboard"))
map("v", { "SHIFT|CTRL" }, wa.PasteFrom("Clipboard"))
map("f", { "LEADER" }, wa.Search("CurrentSelectionOrEmptyString"))

-- -------------------------------- Rotation -------------------------------- --
map("e", { "LEADER" }, wa.RotatePanes("Clockwise"))

w.on("toggle-opacity", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.5
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

-- --------------------------------- Pickers -------------------------------- --
map(" ", "LEADER", wa.QuickSelect)
map("o", { "LEADER" }, u.openUrl)

xplatform_map({
	act = (wa.EmitEvent("toggle-opacity")),
	linux_key = "b",
	linux_modes = "LEADER",
	windows_key = "b",
	windows_modes = "LEADER",
})

map("p", { "LEADER" }, wa.PaneSelect({ alphabet = "asdfghjkl;" }))

map("R", { "LEADER" }, wa.ReloadConfiguration)

-- ---------------------------------- Tabs ---------------------------------- --
map(":", "SHIFT|CTRL", wa.MoveTabRelative(-1))
map("\"", "SHIFT|CTRL", wa.MoveTabRelative(1))

map("h", "SHIFT|CTRL", wa.ActivateTabRelative(-1))
map("l", "SHIFT|CTRL", wa.ActivateTabRelative(1))

map("p", { "SHIFT|CTRL", "SHIFT|SUPER" }, wa.ActivateCommandPalette)

-- ---------------------------------- View ---------------------------------- --
xplatform_map({
	act = wa.ToggleFullScreen,
	linux_key = "Enter",
	linux_modes = "ALT",
	windows_key = "Enter",
	windows_modes = "ALT",
	darwin_key = "f",
	darwin_modes = "CMD|CTRL",
})

map("-", { "CTRL", "SUPER" }, wa.DecreaseFontSize)
map("=", { "CTRL", "SUPER" }, wa.IncreaseFontSize)
map("0", { "CTRL", "SUPER" }, wa.ResetFontSize)

local key_tables = {}

key_tables.search_mode = {
	{ key = "Enter",     mods = "NONE", action = wa.CopyMode("PriorMatch") },
	{ key = "Escape",    mods = "NONE", action = wa.CopyMode("Close") },
	{ key = "c",         mods = "CTRL", action = wa.CopyMode("Close") },
	{ key = "n",         mods = "CTRL", action = wa.CopyMode("NextMatch") },
	{ key = "p",         mods = "CTRL", action = wa.CopyMode("PriorMatch") },
	{ key = "r",         mods = "CTRL", action = wa.CopyMode("CycleMatchType") },
	{ key = "u",         mods = "CTRL", action = wa.CopyMode("ClearPattern") },
	{ key = "PageUp",    mods = "NONE", action = wa.CopyMode("PriorMatchPage") },
	{ key = "PageDown",  mods = "NONE", action = wa.CopyMode("NextMatchPage") },
	{ key = "UpArrow",   mods = "NONE", action = wa.CopyMode("PriorMatch") },
	{ key = "DownArrow", mods = "NONE", action = wa.CopyMode("NextMatch") },
}

key_tables.resize_mode = {
	{ key = "h",          action = wa.AdjustPaneSize({ "Left", 1 }) },
	{ key = "j",          action = wa.AdjustPaneSize({ "Down", 1 }) },
	{ key = "k",          action = wa.AdjustPaneSize({ "Up", 1 }) },
	{ key = "l",          action = wa.AdjustPaneSize({ "Right", 1 }) },
	{ key = "LeftArrow",  action = wa.AdjustPaneSize({ "Left", 1 }) },
	{ key = "DownArrow",  action = wa.AdjustPaneSize({ "Down", 1 }) },
	{ key = "UpArrow",    action = wa.AdjustPaneSize({ "Up", 1 }) },
	{ key = "RightArrow", action = wa.AdjustPaneSize({ "Right", 1 }) },
}

-- ---------------------------- Escape sequences ---------------------------- --
-- for i, _ in pairs(key_tables) do
	-- table.insert(key_tables[i], { key = "Escape", action = "PopKeyTable" })
	-- table.insert(key_tables[i], { key = "Enter", action = "PopKeyTable" })
	-- table.insert(key_tables[i], { key = "c", mods = "CTRL", action = "PopKeyTable" })
-- end

local mouse_bindings = {
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "NONE",
		action = w.action.ScrollByLine(5),
	},
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "NONE",
		action = w.action.ScrollByLine(-5),
	},
}

local M = {}

M.apply = function(config)
	config.leader = leader
	config.keys = keys
	config.key_tables = key_tables
	config.mouse_bindings = mouse_bindings

	config.disable_default_key_bindings = true
end

return M

-- #################################################################################################

-- Copy mode table
-- {
--   { key = 'Tab',        mods = 'NONE',  action = a.CopyMode 'MoveForwardWord' },
--   { key = 'Tab',        mods = 'SHIFT', action = a.CopyMode 'MoveBackwardWord' },
--   { key = 'Enter',      mods = 'NONE',  action = a.CopyMode 'MoveToStartOfNextLine' },
--   { key = 'Escape',     mods = 'NONE',  action = a.CopyMode 'Close' },
--   { key = 'Space',      mods = 'NONE',  action = a.CopyMode { SetSelectionMode = 'Cell' } },
--   { key = '$',          mods = 'NONE',  action = a.CopyMode 'MoveToEndOfLineContent' },
--   { key = '$',          mods = 'SHIFT', action = a.CopyMode 'MoveToEndOfLineContent' },
--   { key = ',',          mods = 'NONE',  action = a.CopyMode 'JumpReverse' },
--   { key = '0',          mods = 'NONE',  action = a.CopyMode 'MoveToStartOfLine' },
--   { key = ';',          mods = 'NONE',  action = a.CopyMode 'JumpAgain' },
--   { key = 'F',          mods = 'NONE',  action = a.CopyMode { JumpBackward = { prev_char = false } } },
--   { key = 'F',          mods = 'SHIFT', action = a.CopyMode { JumpBackward = { prev_char = false } } },
--   { key = 'G',          mods = 'NONE',  action = a.CopyMode 'MoveToScrollbackBottom' },
--   { key = 'G',          mods = 'SHIFT', action = a.CopyMode 'MoveToScrollbackBottom' },
--   { key = 'H',          mods = 'NONE',  action = a.CopyMode 'MoveToViewportTop' },
--   { key = 'H',          mods = 'SHIFT', action = a.CopyMode 'MoveToViewportTop' },
--   { key = 'L',          mods = 'NONE',  action = a.CopyMode 'MoveToViewportBottom' },
--   { key = 'L',          mods = 'SHIFT', action = a.CopyMode 'MoveToViewportBottom' },
--   { key = 'M',          mods = 'NONE',  action = a.CopyMode 'MoveToViewportMiddle' },
--   { key = 'M',          mods = 'SHIFT', action = a.CopyMode 'MoveToViewportMiddle' },
--   { key = 'O',          mods = 'NONE',  action = a.CopyMode 'MoveToSelectionOtherEndHoriz' },
--   { key = 'O',          mods = 'SHIFT', action = a.CopyMode 'MoveToSelectionOtherEndHoriz' },
--   { key = 'T',          mods = 'NONE',  action = a.CopyMode { JumpBackward = { prev_char = true } } },
--   { key = 'T',          mods = 'SHIFT', action = a.CopyMode { JumpBackward = { prev_char = true } } },
--   { key = 'V',          mods = 'NONE',  action = a.CopyMode { SetSelectionMode = 'Line' } },
--   { key = 'V',          mods = 'SHIFT', action = a.CopyMode { SetSelectionMode = 'Line' } },
--   { key = '^',          mods = 'NONE',  action = a.CopyMode 'MoveToStartOfLineContent' },
--   { key = '^',          mods = 'SHIFT', action = a.CopyMode 'MoveToStartOfLineContent' },
--   { key = 'b',          mods = 'NONE',  action = a.CopyMode 'MoveBackwardWord' },
--   { key = 'b',          mods = 'ALT',   action = a.CopyMode 'MoveBackwardWord' },
--   { key = 'b',          mods = 'CTRL',  action = a.CopyMode 'PageUp' },
--   { key = 'c',          mods = 'CTRL',  action = a.CopyMode 'Close' },
--   { key = 'd',          mods = 'CTRL',  action = a.CopyMode { MoveByPage = (0.5) } },
--   { key = 'e',          mods = 'NONE',  action = a.CopyMode 'MoveForwardWordEnd' },
--   { key = 'f',          mods = 'NONE',  action = a.CopyMode { JumpForward = { prev_char = false } } },
--   { key = 'f',          mods = 'ALT',   action = a.CopyMode 'MoveForwardWord' },
--   { key = 'f',          mods = 'CTRL',  action = a.CopyMode 'PageDown' },
--   { key = 'g',          mods = 'NONE',  action = a.CopyMode 'MoveToScrollbackTop' },
--   { key = 'g',          mods = 'CTRL',  action = a.CopyMode 'Close' },
--   { key = 'h',          mods = 'NONE',  action = a.CopyMode 'MoveLeft' },
--   { key = 'j',          mods = 'NONE',  action = a.CopyMode 'MoveDown' },
--   { key = 'k',          mods = 'NONE',  action = a.CopyMode 'MoveUp' },
--   { key = 'l',          mods = 'NONE',  action = a.CopyMode 'MoveRight' },
--   { key = 'm',          mods = 'ALT',   action = a.CopyMode 'MoveToStartOfLineContent' },
--   { key = 'o',          mods = 'NONE',  action = a.CopyMode 'MoveToSelectionOtherEnd' },
--   { key = 'q',          mods = 'NONE',  action = a.CopyMode 'Close' },
--   { key = 't',          mods = 'NONE',  action = a.CopyMode { JumpForward = { prev_char = true } } },
--   { key = 'u',          mods = 'CTRL',  action = a.CopyMode { MoveByPage = (-0.5) } },
--   { key = 'v',          mods = 'NONE',  action = a.CopyMode { SetSelectionMode = 'Cell' } },
--   { key = 'v',          mods = 'CTRL',  action = a.CopyMode { SetSelectionMode = 'Block' } },
--   { key = 'w',          mods = 'NONE',  action = a.CopyMode 'MoveForwardWord' },
--   { key = 'y',          mods = 'NONE',  action = a.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } } },
--   { key = 'PageUp',     mods = 'NONE',  action = a.CopyMode 'PageUp' },
--   { key = 'PageDown',   mods = 'NONE',  action = a.CopyMode 'PageDown' },
--   { key = 'End',        mods = 'NONE',  action = a.CopyMode 'MoveToEndOfLineContent' },
--   { key = 'Home',       mods = 'NONE',  action = a.CopyMode 'MoveToStartOfLine' },
--   { key = 'LeftArrow',  mods = 'NONE',  action = a.CopyMode 'MoveLeft' },
--   { key = 'LeftArrow',  mods = 'ALT',   action = a.CopyMode 'MoveBackwardWord' },
--   { key = 'RightArrow', mods = 'NONE',  action = a.CopyMode 'MoveRight' },
--   { key = 'RightArrow', mods = 'ALT',   action = a.CopyMode 'MoveForwardWord' },
--   { key = 'UpArrow',    mods = 'NONE',  action = a.CopyMode 'MoveUp' },
--   { key = 'DownArrow',  mods = 'NONE',  action = a.CopyMode 'MoveDown' },
-- }

-- #################################################################################################

-- All shortcuts
--   { key = 'f',          mods = 'CTRL',           action = wa.ToggleFullScreen },
--   { key = 'Enter',      mods = 'ALT',            action = wa.ToggleFullScreen },
--   { key = '!',          mods = 'CTRL',           action = wa.ActivateTab(0) },
--   { key = '!',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(0) },
--   { key = '\'',         mods = 'ALT|CTRL',       action = wa.SplitVertical { domain = 'CurrentPaneDomain' } },
--   { key = '\'',         mods = 'SHIFT|ALT|CTRL', action = wa.SplitVertical { domain = 'CurrentPaneDomain' } },
--   { key = '#',          mods = 'CTRL',           action = wa.ActivateTab(2) },
--   { key = '#',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(2) },
--   { key = '$',          mods = 'CTRL',           action = wa.ActivateTab(3) },
--   { key = '$',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(3) },
--   { key = '%',          mods = 'CTRL',           action = wa.ActivateTab(4) },
--   { key = '%',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(4) },
--   { key = '%',          mods = 'ALT|CTRL',       action = wa.SplitHorizontal { domain = 'CurrentPaneDomain' } },
--   { key = '%',          mods = 'SHIFT|ALT|CTRL', action = wa.SplitHorizontal { domain = 'CurrentPaneDomain' } },
--   { key = '&',          mods = 'CTRL',           action = wa.ActivateTab(6) },
--   { key = '&',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(6) },
--   { key = '\'',         mods = 'SHIFT|ALT|CTRL', action = wa.SplitVertical { domain = 'CurrentPaneDomain' } },
--   { key = '(',          mods = 'CTRL',           action = wa.ActivateTab(-1) },
--   { key = '(',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(-1) },
--   { key = ')',          mods = 'CTRL',           action = wa.ResetFontSize },
--   { key = ')',          mods = 'SHIFT|CTRL',     action = wa.ResetFontSize },
--   { key = '*',          mods = 'CTRL',           action = wa.ActivateTab(7) },
--   { key = '*',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(7) },
--   { key = '+',          mods = 'CTRL',           action = wa.IncreaseFontSize },
--   { key = '+',          mods = 'SHIFT|CTRL',     action = wa.IncreaseFontSize },
--   { key = '-',          mods = 'CTRL',           action = wa.DecreaseFontSize },
--   { key = '-',          mods = 'SHIFT|CTRL',     action = wa.DecreaseFontSize },
--   { key = '-',          mods = 'SUPER',          action = wa.DecreaseFontSize },
--   { key = '0',          mods = 'CTRL',           action = wa.ResetFontSize },
--   { key = '0',          mods = 'SHIFT|CTRL',     action = wa.ResetFontSize },
--   { key = '0',          mods = 'SUPER',          action = wa.ResetFontSize },
--   { key = '1',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(0) },
--   { key = '1',          mods = 'SUPER',          action = wa.ActivateTab(0) },
--   { key = '2',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(1) },
--   { key = '2',          mods = 'SUPER',          action = wa.ActivateTab(1) },
--   { key = '3',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(2) },
--   { key = '3',          mods = 'SUPER',          action = wa.ActivateTab(2) },
--   { key = '4',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(3) },
--   { key = '4',          mods = 'SUPER',          action = wa.ActivateTab(3) },
--   { key = '5',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(4) },
--   { key = '5',          mods = 'SHIFT|ALT|CTRL', action = wa.SplitHorizontal { domain = 'CurrentPaneDomain' } },
--   { key = '5',          mods = 'SUPER',          action = wa.ActivateTab(4) },
--   { key = '6',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(5) },
--   { key = '6',          mods = 'SUPER',          action = wa.ActivateTab(5) },
--   { key = '7',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(6) },
--   { key = '7',          mods = 'SUPER',          action = wa.ActivateTab(6) },
--   { key = '8',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(7) },
--   { key = '8',          mods = 'SUPER',          action = wa.ActivateTab(7) },
--   { key = '9',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(-1) },
--   { key = '9',          mods = 'SUPER',          action = wa.ActivateTab(-1) },
--   { key = '=',          mods = 'CTRL',           action = wa.IncreaseFontSize },
--   { key = '=',          mods = 'SHIFT|CTRL',     action = wa.IncreaseFontSize },
--   { key = '=',          mods = 'SUPER',          action = wa.IncreaseFontSize },
--   { key = '@',          mods = 'CTRL',           action = wa.ActivateTab(1) },
--   { key = '@',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(1) },
--   { key = 'C',          mods = 'CTRL',           action = wa.CopyTo 'Clipboard' },
--   { key = 'C',          mods = 'SHIFT|CTRL',     action = wa.CopyTo 'Clipboard' },
--   { key = 'F',          mods = 'CTRL',           action = wa.Search 'CurrentSelectionOrEmptyString' },
--   { key = 'F',          mods = 'SHIFT|CTRL',     action = wa.Search 'CurrentSelectionOrEmptyString' },
--   { key = 'K',          mods = 'CTRL',           action = wa.ClearScrollback 'ScrollbackOnly' },
--   { key = 'K',          mods = 'SHIFT|CTRL',     action = wa.ClearScrollback 'ScrollbackOnly' },
--   { key = 'L',          mods = 'CTRL',           action = wa.ShowDebugOverlay },
--   { key = 'L',          mods = 'SHIFT|CTRL',     action = wa.ShowDebugOverlay },
--   { key = 'M',          mods = 'CTRL',           action = wa.Hide },
--   { key = 'M',          mods = 'SHIFT|CTRL',     action = wa.Hide },
--   { key = 'N',          mods = 'CTRL',           action = wa.SpawnWindow },
--   { key = 'N',          mods = 'SHIFT|CTRL',     action = wa.SpawnWindow },
--   { key = 'P',          mods = 'CTRL',           action = wa.ActivateCommandPalette },
--   { key = 'P',          mods = 'SHIFT|CTRL',     action = wa.ActivateCommandPalette },
--   { key = 'R',          mods = 'CTRL',           action = wa.ReloadConfiguration },
--   { key = 'R',          mods = 'SHIFT|CTRL',     action = wa.ReloadConfiguration },
--   { key = 'T',          mods = 'CTRL',           action = wa.SpawnTab 'CurrentPaneDomain' },
--   { key = 'T',          mods = 'SHIFT|CTRL',     action = wa.SpawnTab 'CurrentPaneDomain' },
--   { key = 'U',          mods = 'CTRL',           action = wa.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
--   { key = 'U',          mods = 'SHIFT|CTRL',     action = wa.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
--   { key = 'V',          mods = 'CTRL',           action = wa.PasteFrom 'Clipboard' },
--   { key = 'V',          mods = 'SHIFT|CTRL',     action = wa.PasteFrom 'Clipboard' },
--   { key = 'W',          mods = 'CTRL',           action = wa.CloseCurrentTab { confirm = true } },
--   { key = 'W',          mods = 'SHIFT|CTRL',     action = wa.CloseCurrentTab { confirm = true } },
--   { key = 'X',          mods = 'CTRL',           action = wa.ActivateCopyMode },
--   { key = 'X',          mods = 'SHIFT|CTRL',     action = wa.ActivateCopyMode },
--   { key = 'Z',          mods = 'CTRL',           action = wa.TogglePaneZoomState },
--   { key = 'Z',          mods = 'SHIFT|CTRL',     action = wa.TogglePaneZoomState },
--   { key = '[',          mods = 'SHIFT|SUPER',    action = wa.ActivateTabRelative(-1) },
--   { key = ']',          mods = 'SHIFT|SUPER',    action = wa.ActivateTabRelative(1) },
--   { key = '^',          mods = 'CTRL',           action = wa.ActivateTab(5) },
--   { key = '^',          mods = 'SHIFT|CTRL',     action = wa.ActivateTab(5) },
--   { key = '_',          mods = 'CTRL',           action = wa.DecreaseFontSize },
--   { key = '_',          mods = 'SHIFT|CTRL',     action = wa.DecreaseFontSize },
--   { key = 'c',          mods = 'SHIFT|CTRL',     action = wa.CopyTo 'Clipboard' },
--   { key = 'c',          mods = 'SUPER',          action = wa.CopyTo 'Clipboard' },
--   { key = 'f',          mods = 'CTRL',           action = wa.ToggleFullScreen },
--   { key = 'f',          mods = 'SHIFT|CTRL',     action = wa.Search 'CurrentSelectionOrEmptyString' },
--   { key = 'f',          mods = 'SUPER',          action = wa.Search 'CurrentSelectionOrEmptyString' },
--   { key = 'k',          mods = 'SHIFT|CTRL',     action = wa.ClearScrollback 'ScrollbackOnly' },
--   { key = 'k',          mods = 'SUPER',          action = wa.ClearScrollback 'ScrollbackOnly' },
--   { key = 'l',          mods = 'SHIFT|CTRL',     action = wa.ShowDebugOverlay },
--   { key = 'm',          mods = 'SHIFT|CTRL',     action = wa.Hide },
--   { key = 'm',          mods = 'SUPER',          action = wa.Hide },
--   { key = 'n',          mods = 'SHIFT|CTRL',     action = wa.SpawnWindow },
--   { key = 'n',          mods = 'SUPER',          action = wa.SpawnWindow },
--   { key = 'p',          mods = 'SHIFT|CTRL',     action = wa.ActivateCommandPalette },
--   { key = 'r',          mods = 'SHIFT|CTRL',     action = wa.ReloadConfiguration },
--   { key = 'r',          mods = 'SUPER',          action = wa.ReloadConfiguration },
--   { key = 't',          mods = 'SHIFT|CTRL',     action = wa.SpawnTab 'CurrentPaneDomain' },
--   { key = 't',          mods = 'SUPER',          action = wa.SpawnTab 'CurrentPaneDomain' },
--   { key = 'u',          mods = 'SHIFT|CTRL',     action = wa.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
--   { key = 'v',          mods = 'SHIFT|CTRL',     action = wa.PasteFrom 'Clipboard' },
--   { key = 'v',          mods = 'SUPER',          action = wa.PasteFrom 'Clipboard' },
--   { key = 'w',          mods = 'SHIFT|CTRL',     action = wa.CloseCurrentTab { confirm = true } },
--   { key = 'w',          mods = 'SUPER',          action = wa.CloseCurrentTab { confirm = true } },
--   { key = 'x',          mods = 'SHIFT|CTRL',     action = wa.ActivateCopyMode },
--   { key = 'z',          mods = 'SHIFT|CTRL',     action = wa.TogglePaneZoomState },
--   { key = '{',          mods = 'SUPER',          action = wa.ActivateTabRelative(-1) },
--   { key = '{',          mods = 'SHIFT|SUPER',    action = wa.ActivateTabRelative(-1) },
--   { key = '}',          mods = 'SUPER',          action = wa.ActivateTabRelative(1) },
--   { key = '}',          mods = 'SHIFT|SUPER',    action = wa.ActivateTabRelative(1) },
--   { key = 'phys:Space', mods = 'SHIFT|CTRL',     action = wa.QuickSelect },
--   { key = 'PageUp',     mods = 'SHIFT',          action = wa.ScrollByPage(-1) },
--   { key = 'PageUp',     mods = 'CTRL',           action = wa.ActivateTabRelative(-1) },
--   { key = 'PageDown',   mods = 'SHIFT',          action = wa.ScrollByPage(1) },
--   { key = 'PageDown',   mods = 'CTRL',           action = wa.ActivateTabRelative(1) },
--   { key = 'h',          mods = 'LEADER',         action = wa.ActivatePaneDirection 'Left' },
--   { key = 'j',          mods = 'LEADER',         action = wa.ActivatePaneDirection 'Down' },
--   { key = 'k',          mods = 'LEADER',         action = wa.ActivatePaneDirection 'Up' },
--   { key = 'l',          mods = 'LEADER',         action = wa.ActivatePaneDirection 'Right' },
--   { key = 'h',          mods = 'SHIFT|LEADER',   action = wa.AdjustPaneSize { 'Left', 1 } },
--   { key = 'j',          mods = 'SHIFT|LEADER',   action = wa.AdjustPaneSize { 'Down', 1 } },
--   { key = 'k',          mods = 'SHIFT|LEADER',   action = wa.AdjustPaneSize { 'Up', 1 } },
--   { key = 'l',          mods = 'SHIFT|LEADER',   action = wa.AdjustPaneSize { 'Right', 1 } },
--   { key = 'Insert',     mods = 'SHIFT',          action = wa.PasteFrom 'PrimarySelection' },
--   { key = 'Insert',     mods = 'CTRL',           action = wa.CopyTo 'PrimarySelection' },
--   { key = 'Copy',       mods = 'NONE',           action = wa.CopyTo 'Clipboard' },
--   { key = 'Paste',      mods = 'NONE',           action = wa.PasteFrom 'Clipboard' },
-- }
