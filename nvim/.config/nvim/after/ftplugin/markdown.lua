-- Read long prose without horizontal scrolling: soft-wrap at word boundaries
-- to the window width, keep list indentation on wrapped lines, and move by
-- screen line (j/k) unless a count is given (5j still jumps real lines).
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = "list:-1"
vim.opt_local.smoothscroll = true

vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { buffer = true, expr = true, silent = true, desc = "Down (screen line)" })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { buffer = true, expr = true, silent = true, desc = "Up (screen line)" })
