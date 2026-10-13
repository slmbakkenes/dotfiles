return {
	src = "https://github.com/ellisonleao/gruvbox.nvim",
	priority = 1000, -- set up before other plugins
	setup = function()
		require("gruvbox").setup() -- defaults: medium contrast; background set in core/options
		vim.cmd.colorscheme("gruvbox")
	end,
}
