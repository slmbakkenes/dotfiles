return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = {
          border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
          border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
        },
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "…",
          symbol_map = {
            Class         = "[CLS]",
            Interface     = "[IFC]",
            Struct        = "[STR]",
            Enum          = "[ENM]",
            EnumMember    = "[EMB]",
            Function      = "[FN]",
            Method        = "[MTH]",
            Constructor   = "[NEW]",
            Variable      = "[VAR]",
            Field         = "[FLD]",
            Property      = "[PRP]",
            Constant      = "[CST]",
            Keyword       = "[KEY]",
            Snippet       = "[SNP]",
            Module        = "[MOD]",
            Text          = "[TXT]",
            File          = "[FILE]",
            Folder        = "[DIR]",
            Color         = "[COL]",
            Reference     = "[REF]",
            Unit          = "[UNT]",
            Value         = "[VAL]",
            TypeParameter = "[TP]",
            Operator      = "[OP]",
            Event         = "[EVT]",
          },
          before = function(entry, vim_item)
            local source_map = {
              nvim_lsp = "[LSP]",
              luasnip  = "[SNP]",
              buffer   = "[BUF]",
              path     = "[PATH]",
            }
            vim_item.menu = source_map[entry.source.name]
              or ("[" .. entry.source.name:upper() .. "]")
            return vim_item
          end,
        }),
      },
    })
  end,
}
