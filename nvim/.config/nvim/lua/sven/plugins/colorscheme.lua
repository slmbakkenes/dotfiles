-- Gruvbox at hard contrast, plus a flatter frame: the editor sits on the hard
-- background (as kitty does), the side pane (nvim-tree) on the
-- normal one, and no separator lines; the panes are told apart by their
-- background alone. Dim text is lifted so it stays readable (>= 4.5:1).

-- the colours per background, from gruvbox's palette
local function colors()
	local p = require("gruvbox").palette
	if vim.o.background == "light" then
		return { panel = p.light0, bg = p.light0_hard, line = p.light1, dim = p.dark4, fg = p.dark1, sub = p.dark4, blue = p.faded_blue, comment = p.dark4 }
	end
	return { panel = p.dark0, bg = p.dark0_hard, line = p.dark1, dim = p.gray, fg = p.light1, sub = p.light3, blue = p.bright_blue, comment = p.light4 }
end

local function frame_highlights()
	local c = colors()
	local hl = function(name, val)
		vim.api.nvim_set_hl(0, name, val)
	end

	hl("WinSeparator", { fg = c.panel, bg = c.panel })
	hl("SignColumn", { bg = c.bg })
	hl("FoldColumn", { fg = c.dim, bg = c.bg })

	-- readable dim text: comments, line numbers, virtual-text hints
	hl("Comment", { fg = c.comment })
	hl("LineNr", { fg = c.dim, bg = c.bg })
	hl("LspInlayHint", { fg = c.dim, bg = c.line })

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
end

return {
	src = "https://github.com/ellisonleao/gruvbox.nvim",
	priority = 1000, -- set up before other plugins
	setup = function()
		-- hard contrast; background set in core/theme. No italics: they are the
		-- hardest to read at small sizes on a scaled screen
		require("gruvbox").setup({
			contrast = "hard",
			italic = { strings = false, emphasis = false, comments = false, operators = false, folds = false },
		})
		vim.api.nvim_create_autocmd("ColorScheme", { pattern = "gruvbox", callback = frame_highlights })
		vim.cmd.colorscheme("gruvbox")
	end,
}
