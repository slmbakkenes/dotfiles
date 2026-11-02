return {
	src = "https://github.com/folke/snacks.nvim",
	priority = 900, -- early: other setups may use vim.ui.select
	setup = function()
		-- mermaid-cli (mmdc) renders with the installed Chrome: its own browser download
		-- does not run under mise
		local chrome = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
		if not vim.env.PUPPETEER_EXECUTABLE_PATH and vim.uv.fs_stat(chrome) then
			vim.env.PUPPETEER_EXECUTABLE_PATH = chrome
		end

		require("snacks").setup({
			input = { enabled = true },
			image = { -- inline images and mermaid (mmdc) in kitty
				enabled = true,
				doc = { max_width = 120, max_height = 60 },
			},
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

		-- full-size view of the image or mermaid diagram under the cursor (Preview.app)
		vim.keymap.set("n", "<leader>mo", function()
			Snacks.image.doc.at_cursor(function(src)
				if not src then
					return vim.notify("No image under cursor", vim.log.levels.WARN)
				end
				vim.ui.open(Snacks.image.image.new(src).file)
			end)
		end, { desc = "Open image/diagram" })

		require("sven.claude").setup()
	end,
}
