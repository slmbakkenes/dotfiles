-- Obsidian vaults in nvim: follow [[wikilinks]], backlinks, note/tag pickers.
-- Rendering is left to render-markdown.nvim (ui disabled here), and frontmatter
-- is never rewritten: the Zenvoices vault is written by the vault-keeper agent.
local vault = "~/Development/zenvoices/zenvoices-vault"

return {
	src = "https://github.com/obsidian-nvim/obsidian.nvim",
	setup = function()
		require("obsidian").setup({
			legacy_commands = false,
			workspaces = {
				{ name = "zenvoices", path = vault },
			},
			picker = { name = "telescope.nvim" },
			ui = { enable = false },
			frontmatter = { enabled = false },
			link = { style = "wiki", format = "shortest" },
			new_notes_location = "notes_subdir",
			notes_subdir = "inbox",
			daily_notes = { enabled = false },
		})

		local keymap = vim.keymap
		keymap.set("n", "<leader>oh", "<cmd>edit " .. vault .. "/home.md<cr>", { desc = "Vault home" })
		keymap.set("n", "<leader>oo", "<cmd>Obsidian quick_switch<cr>", { desc = "Find note" })
		keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Search vault" })
		keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Backlinks" })
		keymap.set("n", "<leader>ol", "<cmd>Obsidian links<cr>", { desc = "Links in note" })
		keymap.set("n", "<leader>ot", "<cmd>Obsidian tags<cr>", { desc = "Tags" })
		keymap.set("n", "<leader>oc", "<cmd>Obsidian toc<cr>", { desc = "Table of contents" })
	end,
}
