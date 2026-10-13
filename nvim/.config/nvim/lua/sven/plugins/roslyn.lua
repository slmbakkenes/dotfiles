return {
	src = "https://github.com/seblyng/roslyn.nvim",
	setup = function()
		require("roslyn").setup({
			broad_search = true, -- search parent dirs for .sln files
		})

		-- LSP settings for roslyn. roslyn.nvim finds `roslyn-language-server` on
		-- PATH (`dotnet tool install -g roslyn-language-server`, see README).
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
