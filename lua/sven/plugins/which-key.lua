return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    preset = "modern",
    delay = 200,
    icons = {
      rules = false,
      mappings = false,
      separator = "▶",
    },
    win = {
      border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
      title = " [ KEYS ] ",
      title_pos = "left",
    },
    spec = {
      { "<leader>b",  group = "Buffer" },
      { "<leader>c",  group = "Code" },
      { "<leader>cr", group = "Run" },
      { "<leader>d",  group = "Debug" },
      { "<leader>e",  group = "Explorer" },
      { "<leader>f",  group = "Find" },
      { "<leader>g",  group = "Git" },
      { "<leader>gh", group = "Hunks" },
      { "<leader>l",  group = "Lazy tools" },
      { "<leader>m",  group = "Markdown" },
      { "<leader>n",  group = "Search" },
      { "<leader>q",  group = "Session" },
      { "<leader>u",  group = "Toggles" },
      { "<leader>w",  group = "Window" },
      { "<leader>x",  group = "Trouble" },
    },
  },
}
