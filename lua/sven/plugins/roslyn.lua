return {
	"seblyng/roslyn.nvim",
	ft = "cs",
	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	opts = {
		broad_search = true, -- search parent dirs for .sln files
	},
	config = function(_, opts)
		require("roslyn").setup(opts)

		-- LSP settings for roslyn. The server binary is a system install, not
		-- mason: `dotnet tool install -g roslyn-language-server` (see README).
		vim.lsp.config("roslyn", {
			cmd = { "roslyn-language-server", "--stdio" },
			settings = {
				["csharp|inlay_hints"] = {
					csharp_enable_inlay_hints_for_implicit_object_creation = true,
					csharp_enable_inlay_hints_for_implicit_variable_types = true,
				},
				["csharp|code_lens"] = {
					dotnet_enable_references_code_lens = true,
				},
				["csharp|completion"] = {
					dotnet_show_completion_items_from_unimported_namespaces = true,
					dotnet_show_name_completion_suggestions = true,
				},
			},
		})
	end,
}
