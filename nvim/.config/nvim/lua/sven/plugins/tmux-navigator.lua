-- Ctrl+hjkl across nvim splits and tmux panes (tmux side lives in tmux.conf).
-- Outside tmux the commands fall back to plain nvim split movement.
vim.g.tmux_navigator_no_mappings = 1 -- must be set before the plugin loads

return {
	src = "https://github.com/christoomey/vim-tmux-navigator",
	setup = function()
		local map = vim.keymap.set
		map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to left split" })
		map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to lower split" })
		map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to upper split" })
		map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to right split" })
	end,
}
