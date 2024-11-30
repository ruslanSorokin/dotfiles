local wezterm = require("wezterm")
local util = require("util")

local wezterm_action = wezterm.action

local M = {
	workspace = {},
}

M.toggle_opacity = function(window, _)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.5
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end

M.workspace.rename = wezterm_action.PromptInputLine({
	description = util.format_line("New workspace name"),
	action = wezterm.action_callback(function(window, pane, line)
		if line then
			wezterm.mux.rename_workspace(window:mux_window():get_workspace(), line)
		end
	end),
})

M.workspace.switch = function(window, pane)
	-- local workspaces = {
	--   { id = home, label = 'Home' },
	--   { id = home .. '/work', label = 'Work' },
	--   { id = home .. '/personal', label = 'Personal' },
	--   { id = home .. '/.config', label = 'Config' },
	-- }
	local workspaces = {}
	for i, wspace in ipairs(wezterm.mux:get_workspace_names()) do
		table.insert(workspaces, { id = tostring(i), label = tostring(wspace) })
	end

	wezterm.log_error(workspaces)

	window:perform_action(
		wezterm_action.InputSelector({
			action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
				if id or label then
					inner_window:perform_action(
						wezterm_action.SwitchToWorkspace({
							name = label,
							spawn = { label = "Workspace: " .. label },
						}),
						inner_pane
					)
				end
			end),
			title = "Open Workspace",
			choices = workspaces,
			fuzzy = true,
			fuzzy_description = "Open Workspace: ",
		}),
		pane
	)
end

return M
