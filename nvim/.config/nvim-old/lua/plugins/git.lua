return {
	{
		"tpope/vim-fugitive", -- TODO: know this plugin
		event = { "VeryLazy" },
		config = function()
			require("plugins.configs.fugitive")
		end,
	},
	{
		-- TODO: start using this plugin
		"lewis6991/gitsigns.nvim",
		event = { "VeryLazy" },
		config = function()
			require("gitsigns").setup({})
		end,
	},
}
