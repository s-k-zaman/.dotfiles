-- vim.cmd.colorscheme "rose-pine"

-- Variant respects vim.o.background, using dawn when light and dark_variant when dark
require("rose-pine").setup({
	--- @usage 'auto'|'main'|'moon'|'dawn'
	variant = "auto",
	--- @usage 'main'|'moon'|'dawn'
	dark_variant = "main",
	disable_background = Colorscheme_transparent,
	disable_float_background = Colorscheme_transparent,
})

