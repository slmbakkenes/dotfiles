require("sven.core")
require("sven.lazy")

-- Machine-local overrides (gitignored). Copy lua/sven/local.lua.example to
-- lua/sven/local.lua for per-machine dap configs, paths, work-specific setup.
pcall(require, "sven.local")
