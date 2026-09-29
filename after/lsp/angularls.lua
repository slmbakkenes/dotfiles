return {
	filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
	root_markers = { "angular.json", "project.json" },
	-- only start inside an Angular/Nx workspace, not in every TS project
	workspace_required = true,
}
