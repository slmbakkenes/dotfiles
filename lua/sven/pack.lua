-- Plugin management via vim.pack (native, nvim 0.12+). Replaces lazy.nvim.
--
-- Each file in lua/sven/plugins/ returns one spec table or a list of them:
--   {
--     src      = "https://github.com/user/repo",   -- required
--     name     = "dir-name",                       -- optional, default: repo name
--     version  = "branch|tag|hash" or vim.version.range(...),  -- optional
--     build    = function(path) end,  -- optional, runs on install/update
--     setup    = function() end,      -- optional, runs once after all add()s
--     priority = 1000,                -- optional, higher setup() runs earlier
--   }
--
-- Plugins load eagerly — no lazy-loading framework. State is tracked in the
-- vim.pack lockfile (nvim-pack-lock.json, committed to git). Update with
-- :lua vim.pack.update() — review the confirmation buffer, :write to apply.

if vim.fn.has("nvim-0.12") == 0 then
	vim.notify("sven.pack requires Neovim 0.12+ (vim.pack)", vim.log.levels.ERROR)
	return
end

-- Collect specs from every module in lua/sven/plugins/
local modules = {}
for file, ftype in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/sven/plugins") do
	local mod = file:match("^(.+)%.lua$")
	if ftype == "file" and mod then
		table.insert(modules, "sven.plugins." .. mod)
	end
end
table.sort(modules)

local specs, setups, builds = {}, {}, {}
for _, modname in ipairs(modules) do
	local result = require(modname)
	local list = result.src and { result } or result
	for _, s in ipairs(list) do
		table.insert(specs, { src = s.src, name = s.name, version = s.version })
		local name = s.name or s.src:match("([^/]+)$")
		if s.build then
			builds[name] = s.build
		end
		if s.setup then
			table.insert(setups, { name = name, fn = s.setup, priority = s.priority or 0 })
		end
	end
end

-- Build hooks, driven by vim.pack events (fires during vim.pack.add/update)
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("SvenPackBuild", {}),
	callback = function(ev)
		local build = builds[ev.data.spec.name]
		if build and (ev.data.kind == "install" or ev.data.kind == "update") then
			build(ev.data.path)
		end
	end,
})

vim.pack.add(specs)

-- Run setups: highest priority first (colorscheme), then alphabetical
table.sort(setups, function(a, b)
	if a.priority ~= b.priority then
		return a.priority > b.priority
	end
	return a.name < b.name
end)
for _, s in ipairs(setups) do
	s.fn()
end
