-- Renoir colorscheme - main loader
-- A warm, golden theme inspired by impressionist art

local M = {}

function M.setup()
  local colors = require("renoir.theme.palette").colors
  local hl = vim.api.nvim_set_hl

  -- Load all highlight definitions
  require("renoir.theme.highlights").setup(colors, hl)
end

return M
