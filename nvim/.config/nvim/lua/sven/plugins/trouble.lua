return {
	src = "https://github.com/folke/trouble.nvim",
	setup = function()
		require("trouble").setup({
			focus = true,
		})

		local map = vim.keymap.set
		map("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>",              { desc = "Workspace diagnostics" })
		map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Document diagnostics" })
		map("n", "<leader>xq", "<cmd>Trouble quickfix toggle<CR>",                 { desc = "Quickfix list" })
		map("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>",                  { desc = "Location list" })
		map("n", "<leader>xt", "<cmd>Trouble todo toggle<CR>",                     { desc = "Todos" })
		map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>",      { desc = "Symbols" })
		map("n", "<leader>xr", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", { desc = "LSP references" })
	end,
}
