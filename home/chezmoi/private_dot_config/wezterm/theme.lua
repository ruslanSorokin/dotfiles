local wezterm = require "wezterm"

local colors = {
  WHITE = "#FFFFFF",
  BLACK = "#000000",

  cattpucin_frappe = {
    ROSEWATER = "#F2D5CF",
    FLAMINGO = "#EEBEBE",
    PINK = "#F4B8E4",
    MAUVE = "#CA9EE6",
    RED = "#E78284",
    MAROON = "#EA999C",
    PEACH = "#EF9F76",
    YELLOW = "#E5C890",
    GREEN = "#A6D189",
    TEAL = "#81C8BE",
    SKY = "#99D1DB",
    SAPPHIRE = "#85C1DC",
    BLUE = "#8CAAEE",
    LAVENDER = "#BABBF1",


    TEXT = "#C6D0F5",
    SUBTEXT_1 = "#B5BFE2",
    SUBTEXT_0 = "#A5ADCE",
    OVERLAY_2 = "#949CBB",
    OVERLAY_1 = "#838BA7",
    OVERLAY_0 = "#737994",
    SURFACE_2 = "#626880",
    SURFACE_1 = "#51576D",
    SURFACE_0 = "#414559",
    BASE = "#303446",
    MANTLE = "#292C3C",
    CRUST = "#232634",
  },

  tokyo_night_moon = {
    GREEN = "#c3e88d",
    GREEN2 = "#4fd6be",
    GREEN3 = "#41a6b5",
    MAGENTA = "#c099ff",
    MAGENTA3 = "#ff007c",
    ORANGE = "#ff966c",
    PURPLE = "#fca7ea",
    RED = "#ff757f",
    RED2 = "#c53b53",
    TEAL = "#4fd6be",
    TERMINAL_BLACK = "#444a73",
    YELLOW = "#ffc777",
    GIT = {
      ADD = "#b8db87",
      CHANGE = "#7ca1f2",
      DELETE = "#e26a75",
    },

    BG = "#222436",
    BG_DARK = "#1e2030",
    BG_HIGHLIGHT = "#2f334d",
    BLUE = "#82aaff",
    BLUE1 = "#3e68d7",
    BLUE2 = "#65bcff",
    BLUE3 = "#0db9d7",
    BLUE6 = "#89ddff",
    BLUE7 = "#b4f9f8",
    BLUE8 = "#394b70",
    COMMENT = "#636da6",
    CYAN = "#86e1fc",
    DARK4 = "#545c7e",
    DARK6 = "#737aa2",
    FG = "#c8d3f5",
    FG_DARK = "#828bb8",
    FG_GUTTER = "#3b4261",
  },
}

local themes = {
  ["Catppuccin Frappe"] = {
    BLACK = colors.BLACK,
    WHITE = colors.WHITE,

    tab_bar = {
      bg = colors.cattpucin_frappe.MANTLE,
      fg = colors.BLACK,
      edge_bg = colors.cattpucin_frappe.CRUST,
      item = {
        fg = colors.BLACK,
        bg = {
          active = colors.cattpucin_frappe.GREEN,
          inactive = colors.cattpucin_frappe.TEXT,
        },
        inactive = { bg = colors.cattpucin_frappe.TEXT, },
        active = { bg = colors.cattpucin_frappe.GREEN, }
      }
    }
  },

  ["Tokyo Night Moon"] = {
    BLACK = colors.BLACK,
    WHITE = colors.WHITE,

    tab_bar = {
      bg = colors.tokyo_night_moon.BG_DARK,
      fg = colors.BLACK,
      edge_bg = colors.tokyo_night_moon.BG_DARK,
      item = {
        fg = colors.WHITE,
        bg = {
          active = colors.tokyo_night_moon.GREEN,
          inactive = colors.cattpucin_frappe.TEXT,
        },
        inactive = { bg = colors.cattpucin_frappe.TEXT, },
        active = { bg = colors.tokyo_night_moon.GREEN, }
      }
    }
  }
}

local M = {
  cattpucin_frappe = "Catppuccin Frappe",
  tokyo_night_storm = "Tokyo Night Moon",
  -- config.color_scheme = "Monokai Pro (Gogh)"
  -- config.color_scheme = "Gruvbox Dark (Gogh)"
  -- config.color_scheme = "Rosé Pine Moon (base16)"
  -- config.color_scheme = "Tokyo Night Storm (Gogh)"
  -- config.color_scheme = "Cattpucin Frappe"
}

---@param theme "Catppuccin Frappe"|"Monokai Pro (Gogh)"|"Tokyo Night Moon"
M.apply = function(config, theme)
  config.color_scheme = theme
  return themes[theme] or wezterm.log_error("unknown theme name: " .. theme)
end

return M
