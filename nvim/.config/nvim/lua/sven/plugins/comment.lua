-- Commenting is native (gc/gcc, nvim 0.10+). This only wires treesitter-aware
-- 'commentstring' into it, so embedded languages comment correctly (ts in
-- Angular templates, jsx/tsx, css-in-js).
return {
	src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
	setup = function()
		vim.g.skip_ts_context_commentstring_module = true

		local get_option = vim.filetype.get_option
		---@diagnostic disable-next-line: duplicate-set-field
		vim.filetype.get_option = function(filetype, option)
			return option == "commentstring"
					and require("ts_context_commentstring.internal").calculate_commentstring()
				or get_option(filetype, option)
		end
	end,
}
