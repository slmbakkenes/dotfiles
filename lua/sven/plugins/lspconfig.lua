-- Data-only in nvim 0.11+: provides lsp/<server>.lua definitions (cmd,
-- filetypes, root_markers) that vim.lsp.enable() resolves, plus :LspRestart
-- and friends. No setup calls needed — servers are enabled in lua/sven/lsp.lua
-- and overridden in after/lsp/.
return {
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{
		src = "https://github.com/folke/lazydev.nvim",
		setup = function()
			require("lazydev").setup({
				library = {
					-- type the `Snacks` global when a file uses it
					{ path = "snacks.nvim", words = { "Snacks" } },
				},
			})
		end,
	},
}
