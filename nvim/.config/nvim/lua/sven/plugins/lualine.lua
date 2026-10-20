-- One flat statusline on the hard background: the mode (CLAUDE in the Claude
-- Code terminal), branch, file and its git diff; filetype and position on the
-- right. Nothing about a terminal buffer's own name or position.

local function in_terminal()
	return vim.bo.buftype == "terminal"
end

local function in_file()
	return not in_terminal()
end

local function theme()
	local p = require("gruvbox").palette
	local light = vim.o.background == "light"
	local bg = light and p.light0_hard or p.dark0_hard
	local fg = light and p.dark4 or p.light4
	local dim = light and p.light4 or p.dark4
	local pill = function(color)
		return {
			a = { fg = bg, bg = color, gui = "bold" },
			b = { fg = light and p.faded_yellow or p.bright_yellow, bg = bg },
			c = { fg = fg, bg = bg },
			x = { fg = dim, bg = bg },
		}
	end
	return {
		normal = pill(fg),
		insert = pill(light and p.faded_blue or p.bright_blue),
		visual = pill(light and p.faded_orange or p.bright_orange),
		replace = pill(light and p.faded_red or p.bright_red),
		command = pill(light and p.faded_yellow or p.bright_yellow),
		terminal = pill(light and p.faded_aqua or p.bright_aqua),
		inactive = pill(dim),
	}
end

local function setup()
	require("lualine").setup({
		options = {
			theme = theme(),
			globalstatus = true,
			component_separators = "",
			section_separators = "",
		},
		sections = {
			lualine_a = {
				{
					"mode",
					fmt = function(mode)
						return in_terminal() and "CLAUDE" or mode
					end,
				},
			},
			lualine_b = { "branch" },
			lualine_c = {
				{ "filename", path = 1, cond = in_file, symbols = { modified = "●" } },
				"diff",
			},
			lualine_x = {
				"diagnostics",
				{ "filetype", icons_enabled = false, cond = in_file },
				{ "location", cond = in_file },
			},
			lualine_y = {},
			lualine_z = {},
		},
	})
end

return {
	src = "https://github.com/nvim-lualine/lualine.nvim",
	setup = function()
		setup()
		-- the theme follows the background
		vim.api.nvim_create_autocmd("ColorScheme", { pattern = "gruvbox", callback = setup })
	end,
}
