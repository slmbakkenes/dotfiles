return {
	{
		src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
		build = function(path)
			vim.system({ "make" }, { cwd = path }):wait()
		end,
	},
	{
		src = "https://github.com/nvim-telescope/telescope.nvim",
		setup = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					path_display = { "smart" },
					prompt_prefix = " ▶ ",
					selection_caret = " ▶ ",
					multi_icon = " ▣ ",
					prompt_title = "[ INPUT ]",
					results_title = "[ DATA ]",
					preview_title = "[ VIEW ]",
					borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
				},
				pickers = {
					find_files  = { prompt_title = "[ FILES ]" },
					live_grep   = { prompt_title = "[ GREP ]" },
					grep_string = { prompt_title = "[ GREP CURSOR ]" },
					buffers     = { prompt_title = "[ BUFFERS ]" },
					oldfiles    = { prompt_title = "[ RECENT ]" },
					help_tags   = { prompt_title = "[ HELP ]" },
					keymaps     = { prompt_title = "[ KEYMAPS ]" },
					diagnostics = { prompt_title = "[ DIAG ]" },
				},
			})

			telescope.load_extension("fzf")

			local keymap = vim.keymap

			-- Find
			keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Find files" })
			keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",    { desc = "Recent files" })
			keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>",   { desc = "Grep string" })
			keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Grep cursor word" })
			keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>",         { desc = "Todos" })
			keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>",     { desc = "Buffers" })
			keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",   { desc = "Help tags" })
			keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>",     { desc = "Keymaps" })
			keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })

			-- Buffer
			keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "Switch buffer" })
			keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>",           { desc = "Delete buffer" })
			keymap.set("n", "<leader>bn", "<cmd>bnext<cr>",             { desc = "Next buffer" })
			keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>",         { desc = "Previous buffer" })
		end,
	},
}
