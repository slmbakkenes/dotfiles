return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<leader>t]],
      direction = "float",
      shade_terminals = true,
      float_opts = {
        border = "curved",
      },
    })

    local Terminal = require("toggleterm.terminal").Terminal

    -- Horizontal terminal (bottom split)
    local horizontal = Terminal:new({
      direction = "horizontal",
      size = 15,
    })

    -- Vertical terminal (right split)
    local vertical = Terminal:new({
      direction = "vertical",
      size = 80,
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>th", function() horizontal:toggle() end, { desc = "Toggle horizontal terminal" })
    vim.keymap.set("n", "<leader>tv", function() vertical:toggle() end, { desc = "Toggle vertical terminal" })
  end,
}
