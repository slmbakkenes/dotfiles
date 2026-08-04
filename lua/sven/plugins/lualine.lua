return {
	src = "https://github.com/nvim-lualine/lualine.nvim",
	setup = function()
		require("lualine").setup({
			options = {
				theme = "gruvbox",
				globalstatus = true,
			},
			sections = {
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
				},
			},
		})
	end,
}
