-- setup is done in advanced_config/colorscheme.lua file
return {
	{ "tjdevries/colorbuddy.nvim", priority = 1000 },
	{ "svrana/neosolarized.nvim", priority = 1000 },
	{ "navarasu/onedark.nvim", priority = 1000 },
	{ "rose-pine/neovim", name = "rose-pine", priority = 1000 },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "craftzdog/solarized-osaka.nvim", lazy = false, opts = {}, priority = 1000 },
	{ "arzg/vim-colors-xcode", priority = 1000 },
}
