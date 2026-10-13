return {
	src = "https://github.com/sindrets/diffview.nvim",
	setup = function()
		local map = vim.keymap.set
		map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>",          { desc = "Open diffview" })
		map("n", "<leader>gD", "<cmd>DiffviewClose<cr>",         { desc = "Close diffview" })
		map("n", "<leader>gl", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
		map("n", "<leader>gL", "<cmd>DiffviewFileHistory<cr>",   { desc = "Branch history" })
	end,
}
