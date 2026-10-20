-- Plays Claude Code's file edits into this nvim as they land: opens the file in
-- the editor window, types the new text in hunk by hunk and marks the changed
-- lines for a few seconds. The nvim-live mod loads this file with dofile() on
-- every call, so state that must outlive a call lives in _G.__nvim_live.
local S = _G.__nvim_live or { queue = {}, busy = false }
_G.__nvim_live = S

local api = vim.api
local ns = api.nvim_create_namespace("nvim_live")
local FRAME_MS = 16
local MAX_MS = 1500 -- typing time per edit, however large
local MIN_CHARS = 4 -- per frame, so small edits still read as typing
local MARK_MS = 4000

local M = {}

local function split(text)
	local l = vim.split(text, "\n", { plain = true })
	if l[#l] == "" then
		table.remove(l)
	end
	return l
end

-- The window the file is shown in: one already showing it, else the previous
-- normal window, else any normal window, else a new split left of the current.
local function editor_win(buf)
	local normal = {}
	for _, w in ipairs(api.nvim_tabpage_list_wins(0)) do
		local b = api.nvim_win_get_buf(w)
		if api.nvim_win_get_config(w).relative == "" and vim.bo[b].buftype == "" then
			if b == buf then
				return w
			end
			normal[w] = true
		end
	end
	local prev = vim.fn.win_getid(vim.fn.winnr("#"))
	if normal[prev] then
		return prev
	end
	local any = next(normal)
	return any or api.nvim_open_win(buf, false, { split = "left", win = 0 })
end

local function mark(buf, from, to, group)
	for row = from, to - 1 do
		pcall(api.nvim_buf_set_extmark, buf, ns, row, 0, { line_hl_group = group, priority = 200 })
	end
end

local function finish(job, rows)
	local buf, win = job.buf, job.win
	pcall(api.nvim_del_autocmd, job.guard)
	-- Back in step with the file on disk: unmodified, its timestamp current.
	api.nvim_buf_call(buf, function()
		vim.cmd("silent! edit!")
	end)
	vim.b[buf].nvim_live = nil
	api.nvim_buf_clear_namespace(buf, ns, 0, -1)
	for _, r in ipairs(rows) do
		mark(buf, r[1], r[2], "DiffAdd")
	end
	if rows[1] and api.nvim_win_is_valid(win) then
		pcall(api.nvim_win_set_cursor, win, { rows[1][1] + 1, 0 })
		api.nvim_win_call(win, function()
			vim.cmd("normal! zz")
		end)
	end
	vim.defer_fn(function()
		if api.nvim_buf_is_valid(buf) then
			api.nvim_buf_clear_namespace(buf, ns, 0, -1)
		end
	end, MARK_MS)
	S.busy = false
	M.pump()
end

local function play(job)
	local path, old, new = job.path, job.old or "", job.new
	local buf = vim.fn.bufadd(path)
	vim.fn.bufload(buf)
	vim.bo[buf].buflisted = true
	if vim.bo[buf].modified and not vim.b[buf].nvim_live then
		vim.notify("Claude changed " .. vim.fn.fnamemodify(path, ":~:.") .. " (your buffer has unsaved changes)", vim.log.levels.WARN)
		S.busy = false
		return M.pump()
	end

	local win = editor_win(buf)
	if api.nvim_win_get_buf(win) ~= buf then
		api.nvim_win_set_buf(win, buf)
	end
	job.buf, job.win = buf, win
	vim.b[buf].nvim_live = true
	-- While it plays the buffer differs from the file on purpose: no reload prompt.
	job.guard = api.nvim_create_autocmd("FileChangedShell", {
		buffer = buf,
		callback = function()
			vim.v.fcs_choice = ""
		end,
	})

	local new_lines = split(new)
	api.nvim_buf_set_lines(buf, 0, -1, false, split(old))
	local hunks = vim.diff(old, new, { result_type = "indices", algorithm = "histogram" })

	local total = 0
	for _, h in ipairs(hunks) do
		for k = h[3], h[3] + h[4] - 1 do
			total = total + #new_lines[k] + 1
		end
	end
	local per_frame = math.max(MIN_CHARS, math.ceil(total / (MAX_MS / FRAME_MS)))

	local rows, i = {}, 0
	local function next_hunk()
		i = i + 1
		local h = hunks[i]
		if not h then
			return finish(job, rows)
		end
		local _, del, start_b, add = h[1], h[2], h[3], h[4]
		local row = add > 0 and start_b - 1 or start_b
		-- Show what goes first, briefly, then take it out.
		mark(buf, row, row + del, "DiffDelete")
		vim.defer_fn(function()
			api.nvim_buf_clear_namespace(buf, ns, row, row + del)
			api.nvim_buf_set_lines(buf, row, row + del, false, {})
			if add == 0 then
				return next_hunk()
			end
			local text = table.concat(vim.list_slice(new_lines, start_b, start_b + add - 1), "\n")
			local shown, count = 0, 0
			local function frame()
				if not api.nvim_buf_is_valid(buf) then
					S.busy = false
					return M.pump()
				end
				shown = math.min(#text, shown + per_frame)
				local typed = vim.split(text:sub(1, shown), "\n", { plain = true })
				api.nvim_buf_set_lines(buf, row, row + count, false, typed)
				count = #typed
				mark(buf, row, row + count, "DiffAdd")
				if api.nvim_win_is_valid(win) then
					local last = typed[#typed]
					pcall(api.nvim_win_set_cursor, win, { row + count, #last })
					api.nvim_win_call(win, function()
						vim.cmd("normal! zz")
					end)
				end
				if shown < #text then
					return vim.defer_fn(frame, FRAME_MS)
				end
				table.insert(rows, { row, row + add })
				next_hunk()
			end
			frame()
		end, del > 0 and 250 or 0)
	end
	next_hunk()
end

function M.pump()
	if S.busy or #S.queue == 0 then
		return
	end
	S.busy = true
	local job = table.remove(S.queue, 1)
	local ok, err = pcall(play, job)
	if not ok then
		S.busy = false
		vim.notify("nvim-live: " .. tostring(err), vim.log.levels.ERROR)
		M.pump()
	end
end

-- Entry point: a JSON file `{ path, old, new }` the mod wrote; read, then removed.
function M.enqueue(file)
	local f = io.open(file, "r")
	if not f then
		return 0
	end
	local job = vim.json.decode(f:read("*a"))
	f:close()
	os.remove(file)
	table.insert(S.queue, job)
	vim.schedule(M.pump)
	return #S.queue
end

return M
