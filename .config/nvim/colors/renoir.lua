-- Renoir colorscheme
-- A warm, golden theme inspired by impressionist art
-- Entry point for :colorscheme renoir

if vim.g.colors_name then
  vim.cmd("hi clear")
end

if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "renoir"

require("renoir.theme").setup()
