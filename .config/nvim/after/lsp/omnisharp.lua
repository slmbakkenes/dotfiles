return {
	filetypes = { "cs" },
	root_markers = { "*.slnx", "*.sln", "*.csproj", ".git" },
	cmd = {
		"omnisharp",
		"--languageserver",
		"--hostPID",
		tostring(vim.fn.getpid()),
	},
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
