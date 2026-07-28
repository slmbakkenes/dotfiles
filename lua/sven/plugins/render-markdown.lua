return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    file_types = { "markdown" },
    code = {
      disable_background = true,
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)

    vim.keymap.set("n", "<leader>mt", "<cmd>RenderMarkdown buf_toggle<cr>", {
      desc = "Toggle markdown render",
    })
  end,
}
