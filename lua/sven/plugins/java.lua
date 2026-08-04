return {
	{ src = "https://github.com/JavaHello/spring-boot.nvim" },
	{
		src = "https://github.com/nvim-java/nvim-java",
		setup = function()
			-- nvim-java's setup is heavyweight; defer it to the first java buffer
			-- (the rest of the config loads eagerly under vim.pack)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				once = true,
				callback = function()
					require("java").setup()
					vim.lsp.enable("jdtls")
				end,
			})
		end,
	},
}
