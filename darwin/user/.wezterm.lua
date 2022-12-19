-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.initial_rows = 24
config.initial_cols = 108
config.font_size = 20

config.window_close_confirmation = "NeverPrompt"
config.audible_bell = "Disabled"

config.dpi = 144
config.native_macos_fullscreen_mode = true

local act = wezterm.action

config.keys = {
  {
    key = 'f',
    mods = 'CMD|CTRL',
    action = wezterm.action.ToggleFullScreen,
  },
}


-- config.color_scheme = 'Gruber (base16)'
config.color_scheme = 'Monokai Pro (Gogh)'

config.font = wezterm.font_with_fallback{
  'JetBrainsMonoNL Nerd Font',
  'MesloLGL Nerd Font',
  'DroidSansMono Nerd Font'
}


-- and finally, return the configuration to wezterm
return config
