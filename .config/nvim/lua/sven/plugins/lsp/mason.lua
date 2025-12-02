return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			-- list of servers for mason to install
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"emmet_ls",
				"prismals",
				"eslint",
				"angularls",
				"omnisharp",
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"eslint_d",
				"csharpier", -- C# formatter
				"netcoredbg", -- .NET debugger
				"jdtls", -- Java LSP
				"java-debug-adapter", -- Java debugger
				"java-test", -- Java test runner
				"google-java-format", -- Java formatter
			},
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
}
