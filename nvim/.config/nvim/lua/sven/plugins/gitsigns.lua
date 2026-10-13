return {
	src = "https://github.com/lewis6991/gitsigns.nvim",
	setup = function()
		require("gitsigns").setup({
			signs = {
				add          = { text = "▍" },
				change       = { text = "▍" },
				delete       = { text = "▁" },
				topdelete    = { text = "▔" },
				changedelete = { text = "▒" },
				untracked    = { text = "▏" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- Navigation
				map("n", "]h", function()
					gs.nav_hunk("next")
				end, "Next hunk")
				map("n", "[h", function()
					gs.nav_hunk("prev")
				end, "Prev hunk")

				-- Hunk actions (Git → Hunks subgroup)
				map("n", "<leader>ghs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
				map("v", "<leader>ghs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage hunk")
				map("v", "<leader>ghr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset hunk")

				map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
				map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
				map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>ghd", gs.diffthis, "Diff this")
				map("n", "<leader>ghD", function()
					gs.diffthis("~")
				end, "Diff this ~")

				-- Blame (top-level Git)
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
			end,
		})
	end,
}
