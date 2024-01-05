return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll" },
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufEnter", "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"folke/neodev.nvim", -- Additional lua configuration, makes nvim stuff amazing!
			},
			{
				"nvimtools/none-ls.nvim",
				config = function()
					require("plugins.configs.lsp.none-ls")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" },
		},
		init = function()
			require("utils.lazy_nvim").lazy_load("nvim-lspconfig")
		end,
		config = function()
			require("plugins.configs.lsp.lspconfig")
			require("plugins.configs.lsp.diagnostics")
		end,
	},
	{ "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
}
