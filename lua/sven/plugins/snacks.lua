return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    input = { enabled = true },
    picker = {
      enabled = true,
      ui_select = true,
    },
  },
}
