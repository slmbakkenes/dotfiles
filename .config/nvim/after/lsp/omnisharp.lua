return {
	filetypes = { "cs" },
	root_markers = { "*.slnx", "*.sln", "*.csproj", ".git" },
	settings = {
		FormattingOptions = {
			EnableEditorConfigSupport = true,
		},
		RoslynExtensionsOptions = {
			EnableAnalyzersSupport = true,
			EnableImportCompletion = true,
		},
	},
}
