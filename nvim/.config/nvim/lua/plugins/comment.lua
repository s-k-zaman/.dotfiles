return {
	{
		"numToStr/Comment.nvim",
		lazy = false,
		opts = {
			-- add any options here
		},
	},
	{
		"folke/todo-comments.nvim",
		event = "BufReadPre",
		dependencies = { "nvim-lua/plenary.nvim" },
		-- TODO: add some commands accessing the lists
		opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}
