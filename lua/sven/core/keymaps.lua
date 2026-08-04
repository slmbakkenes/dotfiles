-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap

-- format-on-save flag (read by conform.nvim, toggled by <leader>uf)
vim.g.format_on_save = false

---------------------
-- General
---------------------

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

---------------------
-- Window / splits
---------------------

keymap.set("n", "<leader>wv", "<C-w>v",        { desc = "Split window vertically" })
keymap.set("n", "<leader>wh", "<C-w>s",        { desc = "Split window horizontally" })
keymap.set("n", "<leader>we", "<C-w>=",        { desc = "Make splits equal size" })
keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" })

---------------------
-- Toggles (<leader>u*)
---------------------

keymap.set("n", "<leader>uf", function()
  vim.g.format_on_save = not vim.g.format_on_save
  vim.notify("Format on save: " .. (vim.g.format_on_save and "on" or "off"))
end, { desc = "Toggle format on save" })

keymap.set("n", "<leader>uh", function()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
  vim.notify("Inlay hints: " .. (not enabled and "on" or "off"))
end, { desc = "Toggle inlay hints" })

keymap.set("n", "<leader>ud", function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
  vim.notify("Diagnostics: " .. (not enabled and "on" or "off"))
end, { desc = "Toggle diagnostics" })

keymap.set("n", "<leader>uv", function()
  local cfg = vim.diagnostic.config() or {}
  local on = cfg.virtual_text ~= false and cfg.virtual_text ~= nil
  vim.diagnostic.config({ virtual_text = (not on) and { prefix = "●", spacing = 4 } or false })
  vim.notify("Virtual text: " .. (not on and "on" or "off"))
end, { desc = "Toggle virtual text" })

keymap.set("n", "<leader>ui", function()
  local ok, snacks = pcall(require, "snacks")
  if not ok then return end
  local on = vim.g.indent_guides_on ~= false
  if on then snacks.indent.disable() else snacks.indent.enable() end
  vim.g.indent_guides_on = not on
  vim.notify("Indent guides: " .. (vim.g.indent_guides_on and "on" or "off"))
end, { desc = "Toggle indent guides" })

keymap.set("n", "<leader>uw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
  vim.notify("Wrap: " .. (vim.opt.wrap:get() and "on" or "off"))
end, { desc = "Toggle line wrap" })

keymap.set("n", "<leader>us", function()
  vim.opt.spell = not vim.opt.spell:get()
  vim.notify("Spell: " .. (vim.opt.spell:get() and "on" or "off"))
end, { desc = "Toggle spell" })
