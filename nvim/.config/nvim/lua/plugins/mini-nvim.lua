return {
	{
		"echasnovski/mini.nvim",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("plugins.configs.mini-ai")
			require("plugins.configs.mini-comment")
			require("plugins.configs.mini-surround")
			-- autopairs
			require("plugins.configs.mini-pairs")
		end,
	},
	{
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = { "BufReadPre", "BufNewFile" },
		opts = require("plugins.configs.mini-indentscope"),
		init = function()
			require("autocmds.mini-indentscope")
		end,
	},
}
