local wezterm = require 'wezterm'

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.initial_rows = 24
config.initial_cols = 108


config.font_size            = 20
-- https://wezfurlong.org/wezterm/config/lua/config/freetype_interpreter_version.html
config.freetype_load_target = "Normal"
config.font                 = wezterm.font_with_fallback {
  {
    family = 'JetBrainsMono NFM',
    harfbuzz_features = { 'calt=0', 'clig=0' },
  },
  {
    family = 'MesloLGL NF',
    harfbuzz_features = { 'calt=0', 'clig=0' },
  },
  {
    family = 'DroidSansMono NF',
    harfbuzz_features = { 'calt=0', 'clig=0' },
  }
}


-- config.color_scheme = 'Gruber (base16)'
config.color_scheme         = 'Monokai Pro (Gogh)'
config.default_cursor_style = 'SteadyUnderline'


config.tab_bar_at_bottom = true

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW   = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW  = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#000000'
    local background = '#000000'
    local foreground = '#ffffff'

    if tab.is_active then
      background = '#606060'
      foreground = '#ffffff'
    elseif hover then
      background = '#606060'
      foreground = '#ffffff'
    end

    local edge_foreground = background

    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)


config.window_close_confirmation = "NeverPrompt"
config.audible_bell              = "Disabled"


config.wsl_domains    = {
  {
    name = 'WSL:Ubuntu',
    distribution = 'Ubuntu',
    username = 'ruslan',
    default_cwd = '/home/ruslan',
    default_prog = { 'fish' },
  },
}
config.default_domain = 'WSL:Ubuntu'


local act = wezterm.action


config.keys = {
  {
    key = 'f',
    mods = 'CTRL',
    action = act.ToggleFullScreen,
  },
}



return config
