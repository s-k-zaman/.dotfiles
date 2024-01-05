return {
	"folke/zen-mode.nvim",
	event = { "VeryLazy" },
	config = function()
		require("zen-mode").setup({
			window = {
				width = 100,
				options = {
					number = true,
					relativenumber = true,
				},
			},
		})

		vim.keymap.set("n", "<leader>zz", function()
			require("zen-mode").toggle()
			vim.wo.wrap = false
		end)
	end,
}
