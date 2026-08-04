return {
	src = "https://github.com/rmagatti/auto-session",
	setup = function()
		require("auto-session").setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>qr", "<cmd>AutoSession search<CR>", { desc = "Restore session" })
		keymap.set("n", "<leader>qs", "<cmd>AutoSession save<CR>",   { desc = "Save session" })
	end,
}
