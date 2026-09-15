-- Rust editor settings (rustfmt emits 4-space indent; global default is 2)
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

-- Run a cargo subcommand from the crate root in a terminal split
local function run_cargo(subcmd)
	local root = vim.fs.root(0, { "Cargo.toml" })
	if not root then
		vim.notify("No Cargo.toml found", vim.log.levels.WARN)
		return
	end
	vim.cmd("split | terminal cd " .. vim.fn.fnameescape(root) .. " && cargo " .. subcmd)
end

local opts = { buffer = 0, silent = true }

vim.keymap.set("n", "<leader>crr", function()
	run_cargo("run")
end, vim.tbl_extend("force", opts, { desc = "Cargo run" }))

vim.keymap.set("n", "<leader>crt", function()
	run_cargo("test")
end, vim.tbl_extend("force", opts, { desc = "Cargo test" }))

vim.keymap.set("n", "<leader>crc", function()
	run_cargo("clippy --all-targets")
end, vim.tbl_extend("force", opts, { desc = "Cargo clippy" }))
