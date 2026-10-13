return {
	src = "https://github.com/folke/which-key.nvim",
	setup = function()
		vim.o.timeoutlen = 500

		require("which-key").setup({
			preset = "modern",
			delay = 200,
			icons = {
				rules = false,
				mappings = false,
				separator = "▶",
			},
			win = {
				border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
				title = " [ KEYS ] ",
				title_pos = "left",
			},
			spec = {
				{ "<leader>b",  group = "Buffer" },
				{ "<leader>c",  group = "Code" },
				{ "<leader>cr", group = "Run" },
				{ "<leader>d",  group = "Debug" },
				{ "<leader>f",  group = "Find" },
				{ "<leader>g",  group = "Git" },
				{ "<leader>gh", group = "Hunks" },
				{ "<leader>m",  group = "Markdown" },
				{ "<leader>n",  group = "Search" },
				{ "<leader>q",  group = "Session" },
				{ "<leader>u",  group = "Toggles" },
				{ "<leader>w",  group = "Window" },
				{ "<leader>x",  group = "Trouble" },
			},
		})
	end,
}
