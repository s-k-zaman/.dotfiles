return {
	{

		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle" },
		config = function()
			-- disable netrw at the very start of your init.lua (strongly advised)
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			-- remap for toggle
			vim.keymap.set("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "toggle file explorer" })
		end,
	},
}
