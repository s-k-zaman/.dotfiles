return {
	{
		"tpope/vim-fugitive", -- TODO: know this plugin
		event = { "VeryLazy" },
		config = function()
			-- require("plugins.configs.fugitive")
			-- TODO: change this keymaps accordingly.
		end,
	},
	{
		-- TODO: start using this plugin
		"lewis6991/gitsigns.nvim",
		event = { "VeryLazy" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
				-- TODO: change keymaps in on_attach property.
				-- on_attach = function(buffer) end,
			})
		end,
	},
}
