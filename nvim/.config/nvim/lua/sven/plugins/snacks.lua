return {
	src = "https://github.com/folke/snacks.nvim",
	priority = 900, -- early: other setups may use vim.ui.select
	setup = function()
		require("snacks").setup({
			input = { enabled = true },
			picker = {
				enabled = true,
				ui_select = true,
			},
			indent = { -- replaces indent-blankline
				indent = { char = "╎" },
				scope = { enabled = true, char = "│" },
			},
		})

		-- replaces vim-maximizer
		vim.keymap.set("n", "<leader>wm", function()
			Snacks.zen.zoom()
		end, { desc = "Maximize/minimize split" })
	end,
}
