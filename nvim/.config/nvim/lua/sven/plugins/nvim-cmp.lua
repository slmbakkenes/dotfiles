-- Completion. Snippets: LSP-provided snippets expand via the built-in
-- vim.snippet — no snippet engine plugin (LuaSnip was dropped as unused).
return {
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{
		src = "https://github.com/hrsh7th/nvim-cmp",
		setup = function()
			local cmp = require("cmp")

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,preview,noselect",
				},
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
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
					{ name = "buffer" },
					{ name = "path" },
				}),
				formatting = {
					-- plain function instead of lspkind: symbol + kind name, source tag
					format = function(entry, vim_item)
						local kind_symbols = {
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
						}
						local source_tags = {
							nvim_lsp = "[LSP]",
							buffer   = "[BUF]",
							path     = "[PATH]",
						}

						local symbol = kind_symbols[vim_item.kind] or ("[" .. tostring(vim_item.kind):upper() .. "]")
						vim_item.kind = symbol .. " " .. vim_item.kind
						vim_item.menu = source_tags[entry.source.name]
							or ("[" .. entry.source.name:upper() .. "]")
						if #vim_item.abbr > 50 then
							vim_item.abbr = vim_item.abbr:sub(1, 49) .. "…"
						end
						return vim_item
					end,
				},
			})
		end,
	},
}
