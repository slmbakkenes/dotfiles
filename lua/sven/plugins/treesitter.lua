return {
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
		build = function()
			-- update installed parsers when the plugin updates
			pcall(vim.cmd.TSUpdate)
		end,
		setup = function()
			require("nvim-treesitter").install({
				"angular",
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"toml",
				"rust",
				"c_sharp",
				"dart",
				"java",
				"scss",
				"styled", -- css`` blocks in Lit / styled-components
			})

			vim.treesitter.language.register("angular", "htmlangular")

			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
}
