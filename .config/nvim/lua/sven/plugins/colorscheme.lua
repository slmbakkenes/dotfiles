-- Renoir colorscheme loader
-- Uses the local colorscheme from colors/renoir.lua

return {
  {
    dir = vim.fn.stdpath("config"),
    name = "renoir-theme",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("renoir")
    end,
  },
}
