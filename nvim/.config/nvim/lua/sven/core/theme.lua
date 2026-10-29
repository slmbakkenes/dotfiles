-- Gruvbox dark/light, chosen per machine by the `theme` script in the dotfiles
-- (it writes ~/.config/theme and sends SIGUSR1 to every running nvim).
local state = vim.fn.expand("~/.config/theme")

local function saved()
	local f = io.open(state)
	if not f then
		return "dark"
	end
	local t = f:read("*l")
	f:close()
	return t == "light" and "light" or "dark"
end

vim.opt.background = saved()

-- Changing 'background' reloads the colorscheme, whose ColorScheme autocmds
-- rebuild the frame highlights and lualine (sven.plugins.colorscheme/lualine).
vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = function()
		local t = saved()
		if vim.o.background ~= t then
			vim.o.background = t
		end
	end,
})
