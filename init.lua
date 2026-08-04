require("sven.core")
require("sven.lazy")
require("sven.lsp") -- after lazy: needs nvim-lspconfig + cmp-nvim-lsp on rtp

-- Machine-local overrides (gitignored). Copy lua/sven/local.lua.example to
-- lua/sven/local.lua for per-machine dap configs, paths, work-specific setup.
pcall(require, "sven.local")
