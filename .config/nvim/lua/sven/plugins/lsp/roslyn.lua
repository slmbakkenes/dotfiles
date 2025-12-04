return {
	"seblyng/roslyn.nvim",
	ft = "cs",
	dependencies = {
		"williamboman/mason.nvim",
	},
	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	opts = {
		broad_search = true, -- search parent dirs for .sln files
	},
	config = function(_, opts)
		require("roslyn").setup(opts)

		-- LSP settings for roslyn
		vim.lsp.config("roslyn", {
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
