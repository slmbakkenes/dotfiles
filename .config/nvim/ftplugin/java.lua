local jdtls = require("jdtls")
local mason_registry = require("mason-registry")

-- Paths from Mason
local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()
local java_debug_path = mason_registry.get_package("java-debug-adapter"):get_install_path()
local java_test_path = mason_registry.get_package("java-test"):get_install_path()

-- Project-specific workspace directory
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Determine OS for config path
local os_config = "config_mac"
if vim.fn.has("linux") == 1 then
	os_config = "config_linux"
elseif vim.fn.has("win32") == 1 then
	os_config = "config_win"
end

-- Debug bundles
local bundles = {
	vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", true), "\n"))

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		jdtls_path .. "/" .. os_config,
		"-data",
		workspace_dir,
	},

	root_dir = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", ".git" }),

	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				useBlocks = true,
			},
		},
	},

	init_options = {
		bundles = bundles,
	},

	on_attach = function(client, bufnr)
		-- Enable debugging support
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		require("jdtls.dap").setup_dap_main_class_configs()

		-- Java-specific keymaps
		local opts = { buffer = bufnr }
		vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
		vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
		vim.keymap.set("v", "<leader>jv", function() jdtls.extract_variable(true) end, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
		vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, vim.tbl_extend("force", opts, { desc = "Extract constant" }))
		vim.keymap.set("v", "<leader>jc", function() jdtls.extract_constant(true) end, vim.tbl_extend("force", opts, { desc = "Extract constant" }))
		vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end, vim.tbl_extend("force", opts, { desc = "Extract method" }))
		vim.keymap.set("n", "<leader>jt", jdtls.test_nearest_method, vim.tbl_extend("force", opts, { desc = "Test nearest method" }))
		vim.keymap.set("n", "<leader>jT", jdtls.test_class, vim.tbl_extend("force", opts, { desc = "Test class" }))
	end,
}

jdtls.start_or_attach(config)
