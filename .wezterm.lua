local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Renoir Clair-Obscur Dark Gold Theme
config.colors = {
	-- Base colors - deep warm shadows
	foreground = "#E8D5B7", -- Warm parchment/canvas tone
	background = "#1A1410", -- Deep warm black (like Renoir's shadows)
	cursor_bg = "#C5A572", -- Muted antique gold
	cursor_border = "#C5A572",
	cursor_fg = "#1A1410",
	selection_bg = "#3D2E1F", -- Dark amber selection
	selection_fg = "#E8D5B7",

	-- ANSI colors - warm palette inspired by Renoir
	ansi = {
		"#2D2118", -- black: deep brown shadow
		"#8B4513", -- red: sienna/burnt umber
		"#B8860B", -- green: dark goldenrod
		"#C5A572", -- yellow: muted antique gold
		"#8B7355", -- blue: warm taupe
		"#6B4423", -- magenta: deep russet
		"#D4A574", -- cyan: warm ochre
		"#E8D5B7", -- white: warm parchment
	},
	brights = {
		"#4A3828", -- bright black: lighter shadow
		"#CD853F", -- bright red: peru/terracotta
		"#DAA520", -- bright green: goldenrod
		"#DEB887", -- bright yellow: burlywood
		"#A0826D", -- bright blue: rosy brown
		"#8B6914", -- bright magenta: dark golden
		"#E6BE8A", -- bright cyan: light ochre
		"#FAF0E6", -- bright white: linen
	},

	-- Tab bar colors
	tab_bar = {
		background = "#0F0C09", -- Darkest shadow for tab bar bg
		active_tab = {
			bg_color = "#2D2118", -- Deep brown
			fg_color = "#C5A572", -- Antique gold
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#1A1410", -- Dark warm black
			fg_color = "#8B7355", -- Muted taupe
		},
		inactive_tab_hover = {
			bg_color = "#3D2E1F", -- Amber highlight
			fg_color = "#DEB887", -- Burlywood
		},
		new_tab = {
			bg_color = "#1A1410",
			fg_color = "#6B4423", -- Russet
		},
		new_tab_hover = {
			bg_color = "#2D2118",
			fg_color = "#C5A572",
		},
	},
}

-- Font settings
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19

-- Tab bar settings
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.tab_max_width = 25
config.show_tab_index_in_tab_bar = true

-- Vim-style tab navigation
config.keys = {
	{ key = "h", mods = "CMD|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "l", mods = "CMD|SHIFT", action = wezterm.action.ActivateTabRelative(1) },
}

-- Window settings
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

return config
