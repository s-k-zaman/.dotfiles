return {
	{
		"tpope/vim-fugitive", -- TODO: know this plugin
		event = { "VeryLazy" },
		config = function()
			require("plugins.configs.fugitive")
		end,
	},
}
