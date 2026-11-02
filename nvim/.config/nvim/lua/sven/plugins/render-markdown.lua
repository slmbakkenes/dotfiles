return {
	src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
	setup = function()
		require("render-markdown").setup({
			file_types = { "markdown" },
			code = {
				disable_background = true,
				-- "hide" conceals the fence lines, which also hides images snacks attaches to them
				border = "thin",
			},
		})

		vim.keymap.set("n", "<leader>mt", "<cmd>RenderMarkdown buf_toggle<cr>", {
			desc = "Toggle markdown render",
		})
	end,
}
