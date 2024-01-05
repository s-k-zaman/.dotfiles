return {
	"stevearc/oil.nvim",
	init = function()
		require("utils.lazy_nvim").lazy_load("oil.nvim")
	end,
	config = function()
		require("oil").setup()
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
