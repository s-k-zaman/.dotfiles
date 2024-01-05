return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		cmd = "Telescope",
		config = function()
			require("plugins.configs.telescope")
		end,
	},
}
