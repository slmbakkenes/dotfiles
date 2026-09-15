-- Native LSP setup (nvim 0.11+). Server definitions (cmd, filetypes,
-- root_markers) come from nvim-lspconfig's lsp/ directory; overrides live in
-- after/lsp/. Binaries are system-installed — see README "Requirements".

local keymap = vim.keymap -- for conciseness

---------------------
-- Servers
---------------------

-- nvim-cmp advertises extra capabilities (snippets, etc.) on top of the
-- built-in ones; apply them to every server via the '*' config.
vim.lsp.config("*", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.enable({
	"ts_ls",
	"html",
	"cssls",
	"tailwindcss",
	"lua_ls",
	"eslint",
	"angularls",
	"rust_analyzer",
	"dockerls",
})
-- Not listed here: dartls (managed by flutter-tools), jdtls (enabled in the
-- nvim-java spec), roslyn (managed by roslyn.nvim).

---------------------
-- Keymaps
---------------------

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf, silent = true }

		-- set keybinds
		opts.desc = "Show LSP references"
		keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

		opts.desc = "Go to declaration"
		keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

		opts.desc = "Show LSP definition"
		keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- show lsp definition

		opts.desc = "Show LSP implementations"
		keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

		opts.desc = "Show LSP type definitions"
		keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

		opts.desc = "Code actions"
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

		opts.desc = "Rename symbol"
		keymap.set("n", "<leader>cn", vim.lsp.buf.rename, opts)

		opts.desc = "Buffer diagnostics"
		keymap.set("n", "<leader>cD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

		opts.desc = "Line diagnostics"
		keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)

		opts.desc = "Go to previous diagnostic"
		keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opts) -- jump to previous diagnostic in buffer
		--
		opts.desc = "Go to next diagnostic"
		keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opts) -- jump to next diagnostic in buffer

		opts.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

		opts.desc = "Restart LSP"
		keymap.set("n", "<leader>cR", ":LspRestart<CR>", opts)
	end,
})

-- vim.lsp.inlay_hint.enable(true)

---------------------
-- Diagnostics
---------------------

local severity = vim.diagnostic.severity

vim.diagnostic.config({
	virtual_text = {
		prefix = function(diagnostic)
			if diagnostic.severity == severity.ERROR then return "▰ " end
			if diagnostic.severity == severity.WARN then return "▲ " end
			if diagnostic.severity == severity.INFO then return "▶ " end
			return "▷ "
		end,
		spacing = 4,
	},
	signs = {
		text = {
			[severity.ERROR] = "▰",
			[severity.WARN] = "▲",
			[severity.HINT] = "▷",
			[severity.INFO] = "▶",
		},
	},
})
