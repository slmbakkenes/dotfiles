-- Claude Code in a terminal split (snacks.terminal), run from the git root.
-- Files it changes on disk reload by themselves, and the nvim-tree sidebar opens
-- the folders above each git-changed file. `nvim <dir>` opens that layout
-- straight away.
local M = {}

local function root()
	return vim.fs.root(0, ".git") or vim.uv.cwd()
end

local function tree()
	return require("nvim-tree.api").tree
end

-- Opens the folders above `paths` in the tree. Leaves the current window where
-- it is.
local function follow(paths)
	if not tree().is_visible() then
		return
	end
	for _, path in ipairs(paths) do
		tree().find_file({ buf = path })
	end
	tree().reload()
end

-- Every git-changed file under the root, absolute.
local function changed(cb)
	local dir = root()
	vim.system({ "git", "status", "--porcelain", "-uall" }, { cwd = dir, text = true }, function(r)
		local out = {}
		for line in (r.stdout or ""):gmatch("[^\n]+") do
			local path = line:sub(4):gsub("^.* %-> ", "")
			table.insert(out, dir .. "/" .. path)
		end
		vim.schedule(function()
			cb(out)
		end)
	end)
end

local function open_explorer(opts)
	tree().toggle({ focus = opts and opts.focus })
	changed(follow)
end

function M.explorer()
	if tree().is_visible() then
		return tree().close()
	end
	open_explorer({ focus = true })
end

function M.toggle(args)
	local cmd = vim.list_extend({ "claude" }, args or {})
	Snacks.terminal.toggle(cmd, {
		cwd = root(),
		win = {
			position = "right",
			width = 0.4,
			-- on the side panes' background (sven.plugins.colorscheme)
			wo = {
				winhighlight = "Normal:ClaudeNormal,NormalNC:ClaudeNormal,WinBar:ClaudeWinBar,WinBarNC:ClaudeWinBar,WinSeparator:WinSeparator",
				winbar = " %{get(b:, 'term_title', '')}", -- without snacks' "1: "
			},
		},
	})
end

-- The most recent file of v:oldfiles under `dir`, if any is still there.
local function last_file(dir)
	for _, f in ipairs(vim.v.oldfiles) do
		if vim.startswith(f, dir .. "/") and vim.uv.fs_stat(f) then
			return f
		end
	end
end

-- `nvim <dir>`: the project layout instead of a directory listing. Explorer left, the
-- last file edited in the project in the middle, Claude Code right and focused.
function M.open_project(dir)
	vim.cmd.cd(vim.fn.fnameescape(dir))
	local file = last_file(vim.fn.getcwd())
	if file then
		vim.cmd.edit(vim.fn.fnameescape(file))
	else
		vim.cmd.enew()
	end
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= vim.api.nvim_get_current_buf() and vim.fn.isdirectory(vim.api.nvim_buf_get_name(buf)) == 1 then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
	open_explorer({ focus = false })
	M.toggle()
end

function M.setup()
	vim.o.autoread = true

	-- Terminal mode fires no CursorHold, so poll as well while Claude works.
	local group = vim.api.nvim_create_augroup("sven_claude", { clear = true })
	vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
		group = group,
		command = "silent! checktime",
	})
	vim.uv.new_timer():start(1000, 1000, vim.schedule_wrap(function()
		if vim.fn.getcmdwintype() == "" then
			vim.cmd("silent! checktime")
		end
	end))

	-- Read now, before a directory handler can rename the argument.
	local arg = vim.fn.argc() == 1 and vim.fn.argv(0) or ""
	if vim.fn.isdirectory(arg) == 1 then
		local dir = vim.fn.fnamemodify(arg, ":p"):gsub("/$", "")
		vim.api.nvim_create_autocmd("VimEnter", {
			group = group,
			nested = true,
			once = true,
			callback = vim.schedule_wrap(function()
				M.open_project(dir)
			end),
		})
	end
	local map = vim.keymap.set
	map({ "n", "t" }, "<C-,>", M.toggle, { desc = "Toggle Claude Code" })
	map("n", "<leader>ac", M.toggle, { desc = "Toggle Claude Code" })
	map("n", "<leader>aC", function()
		M.toggle({ "--continue" })
	end, { desc = "Claude Code: continue last session" })
	map("n", "<leader>e", M.explorer, { desc = "Toggle file explorer" })
	map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Leave Claude Code to the left split" })
end

return M
