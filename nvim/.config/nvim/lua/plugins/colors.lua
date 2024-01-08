return {
	{
		{ "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
	},
	{
		"NvChad/nvim-colorizer.lua",
        lazy=false,
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
}
