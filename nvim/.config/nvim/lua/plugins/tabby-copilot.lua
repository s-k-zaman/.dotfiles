return {
	"TabbyML/vim-tabby",
	event = { "BufEnter" },
	init = function()
		require("utils.lazy_nvim").lazy_load("vim-tabby")
	end,
	config = function()
		vim.g.tabby_trigger_mode = "auto" -- optinos are ['manual', 'auto']
		vim.g.tabby_keybinding_accept = "<C-y>"
		vim.g.tabby_keybinding_trigger_or_dismiss = "<C-\\>"
	end,
}
