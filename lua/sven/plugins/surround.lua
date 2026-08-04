return {
	src = "https://github.com/kylechui/nvim-surround",
	version = vim.version.range("*"), -- latest stable tag
	setup = function()
		require("nvim-surround").setup()
	end,
}
