-- onedark :FIX: which key bg is not transparent.
-- catppuccin
-- tokyonight : FIX: lualine custom module problem
-- rose-pine : FIX: lualine custom module problem
-- neosolarized :FIX: colorbuddy not working.
local colorschemeName = "onedark"
Colorscheme_transparent = false

-- comments are not becoming italic. -> i think due to fonts.
require("plugins.configs.colorschemes." .. colorschemeName)

function ColorMyPencils(color)
	color = color or "onedark"

	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", {
		bg = "none",
	})
	vim.api.nvim_set_hl(0, "NormalFloat", {
		bg = "none",
	})
end

if Colorscheme_transparent then
	ColorMyPencils()
else
	vim.cmd.colorscheme(colorschemeName)
end
