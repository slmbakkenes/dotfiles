return {
	"nvim-java/nvim-java",
	ft = "java",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"mfussenegger/nvim-dap",
		"JavaHello/spring-boot.nvim",
	},
	config = function()
		require("java").setup()
		vim.lsp.enable("jdtls")
	end,
}
