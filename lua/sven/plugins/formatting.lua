return {
	src = "https://github.com/stevearc/conform.nvim",
	setup = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				cs = { "csharpier" },
				dart = { "dart_format" },
				java = { "google-java-format" },
				scss = { "prettier" },
				htmlangular = { "prettier" },
			},
			format_on_save = function(bufnr)
				if not vim.g.format_on_save then return end
				return { lsp_fallback = true, timeout_ms = 1000 }
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>cf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file/range" })
	end,
}
