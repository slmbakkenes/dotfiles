return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Open diffview" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>",         desc = "Close diffview" },
    { "<leader>gl", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    { "<leader>gL", "<cmd>DiffviewFileHistory<cr>",   desc = "Branch history" },
  },
}
