return {
	src = "https://github.com/folke/snacks.nvim",
	priority = 900, -- early: other setups may use vim.ui.select
	setup = function()
		require("snacks").setup({
			input = { enabled = true },
			picker = {
				enabled = true,
				ui_select = true,
			},
			indent = { -- replaces indent-blankline
				indent = { char = "╎" },
				scope = { enabled = true, char = "│" },
			},
		})

		-- replaces vim-maximizer
		vim.keymap.set("n", "<leader>wm", function()
			Snacks.zen.zoom()
		end, { desc = "Maximize/minimize split" })

		-- a shell at the bottom for npm, dotnet, docker; keeps running while hidden
		local function shell()
			Snacks.terminal.toggle(nil, { cwd = vim.fs.root(0, ".git") or vim.uv.cwd() })
		end
		vim.keymap.set({ "n", "t" }, "<C-/>", shell, { desc = "Toggle terminal" })
		vim.keymap.set({ "n", "t" }, "<C-_>", shell, { desc = "which_key_ignore" })
		vim.keymap.set("n", "<leader>gg", function()
			Snacks.lazygit()
		end, { desc = "Lazygit" })
		vim.keymap.set("n", "<leader>D", function()
			Snacks.terminal("lazydocker", { win = { position = "float", width = 0.9, height = 0.9 } })
		end, { desc = "Lazydocker" })

		require("sven.claude").setup()
	end,
}
