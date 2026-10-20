-- Gruvbox, plus a flatter frame: the side panes (nvim-tree, Claude Code) sit on
-- the hard background, the editor on the normal one, and no separator lines;
-- the panes are told apart by their background alone.

-- the colours per background, from gruvbox's palette
local function colors()
	local p = require("gruvbox").palette
	if vim.o.background == "light" then
		return { panel = p.light0_hard, bg = p.light0, line = p.light1, dim = p.light4, fg = p.dark1, sub = p.dark4, blue = p.faded_blue }
	end
	return { panel = p.dark0_hard, bg = p.dark0, line = p.dark1, dim = p.dark4, fg = p.light1, sub = p.light4, blue = p.bright_blue }
end

local function frame_highlights()
	local c = colors()
	local hl = function(name, val)
		vim.api.nvim_set_hl(0, name, val)
	end

	hl("WinSeparator", { fg = c.panel, bg = c.panel })
	hl("SignColumn", { bg = c.bg })
	hl("FoldColumn", { fg = c.dim, bg = c.bg })

	-- nvim-tree
	hl("NvimTreeNormal", { fg = c.fg, bg = c.panel })
	hl("NvimTreeNormalNC", { link = "NvimTreeNormal" })
	hl("NvimTreeEndOfBuffer", { fg = c.panel, bg = c.panel })
	hl("NvimTreeWinSeparator", { link = "WinSeparator" })
	hl("NvimTreeCursorLine", { bg = c.line })
	hl("NvimTreeRootFolder", { fg = c.sub, bold = true })
	hl("NvimTreeFolderIcon", { fg = c.blue })
	hl("NvimTreeFolderName", { fg = c.fg })
	hl("NvimTreeOpenedFolderName", { fg = c.fg })
	hl("NvimTreeEmptyFolderName", { fg = c.sub })
	hl("NvimTreeSpecialFile", { fg = c.fg })
	hl("NvimTreeOpenedFile", { fg = c.fg, bold = true })
	hl("NvimTreeIndentMarker", { fg = c.line })

	-- the Claude Code terminal (sven.claude sets these on its window)
	hl("ClaudeNormal", { fg = c.fg, bg = c.panel })
	hl("ClaudeWinBar", { fg = c.sub, bg = c.panel })
end

return {
	src = "https://github.com/ellisonleao/gruvbox.nvim",
	priority = 1000, -- set up before other plugins
	setup = function()
		require("gruvbox").setup() -- defaults: medium contrast; background set in core/options
		vim.api.nvim_create_autocmd("ColorScheme", { pattern = "gruvbox", callback = frame_highlights })
		vim.cmd.colorscheme("gruvbox")
	end,
}
