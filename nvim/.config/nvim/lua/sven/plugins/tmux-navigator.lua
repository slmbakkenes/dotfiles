-- Ctrl+hjkl across nvim splits and tmux panes when nvim runs inside tmux
-- (tmux side lives in tmux.conf; outside tmux, vim-kitty-navigator handles it)
vim.g.tmux_navigator_no_mappings = 1 -- must be set before the plugin loads

return {
	src = "https://github.com/christoomey/vim-tmux-navigator",
	setup = function()
		if not vim.env.TMUX then
			return
		end
		local map = vim.keymap.set
		map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to left split" })
		map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to lower split" })
		map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to upper split" })
		map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to right split" })
	end,
}
