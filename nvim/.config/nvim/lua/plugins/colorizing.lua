return {
	{
		"NvChad/nvim-colorizer.lua",
		init = function()
			require("utils.lazy_nvim").lazy_load("nvim-colorizer.lua")
		end,
		config = function()
			require("colorizer").setup({
				user_default_options = {
					tailwind = true,
				},
			})
			-- execute colorizer as soon as possible
			vim.defer_fn(function()
				require("colorizer").attach_to_buffer(0)
			end, 0)
		end,
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		-- optionally, override the default options:
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})
		end,
	},
}
