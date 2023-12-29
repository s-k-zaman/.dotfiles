-- setup is done in advanced_config/colorscheme.lua file
return {
	{ "tjdevries/colorbuddy.nvim" },
	{ "svrana/neosolarized.nvim" },
	{ "navarasu/onedark.nvim" },
	{ "rose-pine/neovim", name = "rose-pine" },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}
