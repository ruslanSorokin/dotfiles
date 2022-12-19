local w = require("wezterm")

local M = {}

---@return function
M.new_mapper = function(k)
	return function(key, mods, action)
		if type(mods) == "string" then
			table.insert(k, { key = key, mods = mods, action = action })
		elseif type(mods) == "table" then
			for _, mod in pairs(mods) do
				table.insert(k, { key = key, mods = mod, action = action })
			end
		end
	end
end

---check if we're on Windows
---@return boolean
M.is_windows = function()
	return string.find(w.target_triple, "windows") ~= nil
end

---check if we're on Linux
---@return boolean
M.is_linux = function()
	return string.find(w.target_triple, "linux") ~= nil
end

---check if we're on macOS
---@return boolean
M.is_darwin = function()
	return string.find(w.target_triple, "darwin") ~= nil
end

w.GLOBAL.enable_tab_bar = true
M.toggleTabBar = w.action_callback(function(window)
	w.GLOBAL.enable_tab_bar = not w.GLOBAL.enable_tab_bar
	window:set_config_overrides({ enable_tab_bar = w.GLOBAL.enable_tab_bar })
end)

local wa = w.action

M.openUrl = wa.QuickSelectArgs({
	label = "open url",
	patterns = { "https?://\\S+" },
	action = w.action_callback(function(window, pane)
		local url = window:get_selection_text_for_pane(pane)
		w.open_with(url)
	end),
})

return M
