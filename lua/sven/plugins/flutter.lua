return {
	"akinsho/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
	},
	config = function()
		require("flutter-tools").setup({
			debugger = {
				enabled = true,
				run_via_dap = true,
			},
			widget_guides = {
				enabled = true,
			},
		})
		vim.lsp.document_color.enable(true)
	end,
}
