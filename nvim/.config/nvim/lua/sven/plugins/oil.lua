return {
	src = "https://github.com/stevearc/oil.nvim",
	setup = function()
		require("oil").setup({
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_edits = false,
			view_options = {
				show_hidden = true,
			},
			keymaps = {
				["g?"]    = "actions.show_help",
				["<CR>"]  = "actions.select",
				["<C-s>"] = { "actions.select", opts = { vertical = true } },
				["<C-h>"] = { "actions.select", opts = { horizontal = true } },
				["-"]     = "actions.parent",
				["_"]     = "actions.open_cwd",
				["q"]     = "actions.close",
			},
		})

		vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory (oil)" })

		-- LSP-aware file renames (replaces nvim-lsp-file-operations):
		-- snacks.rename notifies attached servers via willRenameFiles
		vim.api.nvim_create_autocmd("User", {
			pattern = "OilActionsPost",
			callback = function(event)
				if event.data.actions[1].type == "move" then
					Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
				end
			end,
		})
	end,
}
