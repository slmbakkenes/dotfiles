return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000, -- load before other plugins
  config = function()
    require("gruvbox").setup({
      contrast = "", -- "hard", "soft" or "" (medium)
    })
    vim.o.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  end,
}
