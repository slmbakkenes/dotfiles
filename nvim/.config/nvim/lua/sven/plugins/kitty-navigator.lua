-- Ctrl+hjkl across nvim splits and kitty splits (kitty side lives in kitty.conf)
vim.g.kitty_navigator_no_mappings = 1 -- must be set before the plugin loads

return {
	src = "https://github.com/knubie/vim-kitty-navigator",
	setup = function()
		if vim.env.TMUX then
			return -- inside tmux, vim-tmux-navigator owns Ctrl+hjkl
		end
		local map = vim.keymap.set
		map("n", "<C-h>", "<cmd>KittyNavigateLeft<cr>", { desc = "Go to left split" })
		map("n", "<C-j>", "<cmd>KittyNavigateDown<cr>", { desc = "Go to lower split" })
		map("n", "<C-k>", "<cmd>KittyNavigateUp<cr>", { desc = "Go to upper split" })
		map("n", "<C-l>", "<cmd>KittyNavigateRight<cr>", { desc = "Go to right split" })
	end,
}
