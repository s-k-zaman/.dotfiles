return {
	{

		"nvim-treesitter/nvim-treesitter",
		cmd = { "TSInstall", "TSBufEnable" },
		build = ":TSUpdate",
		config = function()
			require("plugins.configs.treesitter")
		end,
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				lazy = true,
				init = function()
					vim.g.skip_ts_context_commentstring_module = true
				end,
			},
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					-- disable rtp plugin, as we only need its queries for mini.ai
					-- In case other textobject modules are enabled, we will load them
					-- once nvim-treesitter is loaded
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
					load_textobjects = true
				end,
			},
		},
	},
}
