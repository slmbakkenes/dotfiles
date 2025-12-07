return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count
    local palette = require("sven.theme.palette").colors

    local colors = {
      gold = palette.bg_search,      -- #C5A572 antique gold (normal mode)
      ochre = palette.gold,          -- #D4A574 warm ochre (insert mode)
      sienna = palette.sienna,       -- #CD853F terracotta (visual mode)
      yellow = palette.warning,      -- #D4A04A (command mode)
      red = palette.error,           -- #D46A6A (replace mode)
      fg = palette.fg,
      bg = palette.bg_dark,
      inactive_bg = palette.bg_highlight,
      semilightgray = palette.fg_gutter,
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.gold, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.ochre, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.sienna, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = my_lualine_theme,
        globalstatus = true,
      },
      sections = {
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = palette.amber },
          },
          { "fileformat" },
          { "filetype" },
        },
        lualine_y = {},
      },
    })
  end,
}
