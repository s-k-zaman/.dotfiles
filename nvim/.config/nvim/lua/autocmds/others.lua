local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local ZamanGroup = augroup("Zaman", {})
local yank_group = augroup("HighlightYank", {})

-- function R(name)
-- 	require("plenary.reload").reload_module(name)
-- end

-- show a highlight on yanked/copied portion.
autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- following: I think removes trailing whitespaces. Need to confirm.
autocmd({ "BufWritePre" }, {
	group = ZamanGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})
