return {
	src = "https://github.com/akinsho/flutter-tools.nvim",
	setup = function()
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
