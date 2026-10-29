-- File tree sidebar: a plain buffer (vim motions, `/`), and nvim-tree's own keys
-- for files: a add (end in / for a folder), d delete, r rename, c copy, x cut,
-- p paste, g? help; l opens and h closes a folder. `-` shows the current file in it.
--
-- Git styled like the filetree Claude Code mod: one letter at the right edge
-- (M modified, A staged, R renamed, U untracked, D deleted, ! conflict) and
-- the name in the same colour.

-- status -> colour, for the letter and the file and folder names
local GIT_COLORS = {
	Dirty = "GruvboxYellow",
	Staged = "GruvboxGreen",
	New = "GruvboxGreen",
	Renamed = "GruvboxPurple",
	Deleted = "GruvboxRed",
	Merge = "GruvboxRed",
	Ignored = "Comment",
}

local function git_highlights()
	for status, color in pairs(GIT_COLORS) do
		vim.api.nvim_set_hl(0, "NvimTreeGit" .. status .. "Icon", { link = color })
		vim.api.nvim_set_hl(0, "NvimTreeGitFile" .. status .. "HL", { link = color })
		vim.api.nvim_set_hl(0, "NvimTreeGitFolder" .. status .. "HL", { link = color })
	end
	local red = vim.api.nvim_get_hl(0, { name = "GruvboxRed", link = false }).fg
	vim.api.nvim_set_hl(0, "NvimTreeGitDeletedName", { fg = red, strikethrough = true })
end

-- Deleted files are no nodes, so nvim-tree never draws them. After each render
-- they are added as virtual lines under their open folder (or the nearest open
-- one above it): the name struck through in red and a D at the right edge.
local deleted_ns = vim.api.nvim_create_namespace("nvim_tree_deleted")
local toplevels = {} -- tree root -> git toplevel ("" outside git)

-- The leading spaces and indent markers of a tree row (multibyte, so no
-- Lua character class).
local function markers(text)
	local out, i = "", 1
	while true do
		local ch = text:sub(i, i) == " " and " " or text:sub(i, i + 2)
		if ch ~= " " and ch ~= "│" and ch ~= "└" then
			return out
		end
		out, i = out .. ch, i + #ch
	end
end

local function draw_deleted(bufnr, winid, root, deleted)
	if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(winid) then
		return
	end
	vim.api.nvim_buf_clear_namespace(bufnr, deleted_ns, 0, -1)
	local core = require("nvim-tree.core")
	local explorer = core.get_explorer()
	if not explorer or explorer.absolute_path ~= root then
		return
	end
	local line_of, open, indent_of, last_line = {}, {}, {}, 0
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for line, node in pairs(explorer:get_nodes_by_line(core.get_nodes_starting_line())) do
		line_of[node.absolute_path] = line
		open[node.absolute_path] = node.open
		last_line = math.max(last_line, line)
		-- the indent markers before the node's icon and name
		local text = lines[line] or ""
		local at = text:find(node.name, 1, true)
		local before = at and text:sub(1, at - 1) or ""
		indent_of[node.absolute_path] = markers(before)
	end
	open[root] = true

	-- A row in `dir`: a sibling's indent ending in └, else the folder's own
	-- indent one level deeper.
	local function indent_in(dir)
		if dir == root then
			return "  "
		end
		for p, indent in pairs(indent_of) do
			if vim.fs.dirname(p) == dir then
				return (indent:gsub("│ $", "└ "))
			end
		end
		return (indent_of[dir] or "  "):gsub("└", " ") .. "└ "
	end

	local width = vim.api.nvim_win_get_width(winid)
	local below = {} -- line -> virtual lines
	for _, path in ipairs(deleted) do
		local dir = vim.fs.dirname(path)
		while dir ~= root and not line_of[dir] and #dir > #root do
			dir = vim.fs.dirname(dir)
		end
		if open[dir] then
			-- after the folder's last visible descendant
			local anchor = line_of[dir] or 0
			for p, line in pairs(line_of) do
				if vim.startswith(p, dir .. "/") then
					anchor = math.max(anchor, line)
				end
			end
			if dir == root then
				anchor = last_line
			end
			local indent = indent_in(dir)
			local name = path:sub(#dir + 2)
			local pad = math.max(1, width - vim.fn.strdisplaywidth(indent .. "  " .. name) - 2)
			below[anchor] = below[anchor] or {}
			table.insert(below[anchor], {
				{ indent, "NvimTreeIndentMarker" },
				{ "  " .. name, "NvimTreeGitDeletedName" },
				{ string.rep(" ", pad) },
				{ "D", "NvimTreeGitDeletedIcon" },
			})
		end
	end
	for line, virt_lines in pairs(below) do
		pcall(vim.api.nvim_buf_set_extmark, bufnr, deleted_ns, math.max(0, line - 1), 0, { virt_lines = virt_lines })
	end
end

local function show_deleted(bufnr, winid)
	local explorer = require("nvim-tree.core").get_explorer()
	if not explorer then
		return
	end
	local root = explorer.absolute_path
	local function status(top)
		if top == "" then
			return
		end
		vim.system({ "git", "-C", root, "status", "--porcelain", "-z", "--no-renames", "--untracked-files=no" }, {}, function(r)
			local deleted = {}
			for entry in (r.stdout or ""):gmatch("[^%z]+") do
				if entry:sub(1, 2):find("D") then
					local path = top .. "/" .. entry:sub(4)
					if vim.startswith(path, root .. "/") then
						table.insert(deleted, path)
					end
				end
			end
			table.sort(deleted)
			vim.schedule(function()
				draw_deleted(bufnr, winid, root, deleted)
			end)
		end)
	end
	if toplevels[root] then
		return status(toplevels[root])
	end
	vim.system({ "git", "-C", root, "rev-parse", "--show-toplevel" }, { text = true }, function(r)
		toplevels[root] = r.code == 0 and vim.trim(r.stdout) or ""
		status(toplevels[root])
	end)
end

return {
	src = "https://github.com/nvim-tree/nvim-tree.lua",
	setup = function()
		require("nvim-tree").setup({
			hijack_netrw = false,
			hijack_directories = { enable = false },
			view = { width = 40 },
			renderer = {
				group_empty = true,
				root_folder_label = ":t", -- the folder's name, not its path
				highlight_git = "name",
				indent_markers = { enable = true },
				icons = {
					git_placement = "right_align",
					glyphs = {
						git = {
							unstaged = "M",
							staged = "A",
							unmerged = "!",
							renamed = "R",
							untracked = "U",
							deleted = "D",
							ignored = "◌",
						},
					},
				},
				decorators = {
					"Git",
					"Open",
					"Hidden",
					"Modified",
					"Bookmark",
					"Diagnostics",
					"Copied",
					"Cut",
				},
			},
			update_focused_file = { enable = true },
			filters = { dotfiles = false },
			-- the defaults, plus l to open a folder or file and h to close the
			-- folder (or the one it is in)
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				api.config.mappings.default_on_attach(bufnr)
				local function map(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = bufnr, nowait = true, desc = "nvim-tree: " .. desc })
				end
				map("l", api.node.open.edit, "Open")
				map("h", function()
					local node = api.tree.get_node_under_cursor()
					if node and node.nodes and node.open then
						api.node.open.edit()
					else
						api.node.navigate.parent_close()
					end
				end, "Close folder")
			end,
		})

		git_highlights()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = git_highlights })

		local api = require("nvim-tree.api")
		vim.keymap.set("n", "-", function()
			api.tree.find_file({ open = true, focus = true })
		end, { desc = "Show current file in the tree" })

		api.events.subscribe(api.events.Event.TreeRendered, function(data)
			show_deleted(data.bufnr, data.winnr)
		end)

		-- LSP-aware renames: snacks.rename notifies servers via willRenameFiles
		api.events.subscribe(api.events.Event.NodeRenamed, function(data)
			Snacks.rename.on_rename_file(data.old_name, data.new_name)
		end)
	end,
}
