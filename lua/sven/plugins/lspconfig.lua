-- Data-only in nvim 0.11+: provides lsp/<server>.lua definitions (cmd,
-- filetypes, root_markers) that vim.lsp.enable() resolves, plus :LspRestart
-- and friends. No setup calls needed — servers are enabled in lua/sven/lsp.lua
-- and overridden in after/lsp/.
return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/lazydev.nvim", ft = "lua", opts = {} },
	},
}
