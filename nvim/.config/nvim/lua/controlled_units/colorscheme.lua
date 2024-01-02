local utils = require("utils")
-- onedark :FIX: which key bg is not transparent.
-- catppuccin
-- tokyonight : FIX: lualine custom module problem
-- rose-pine : FIX: lualine custom module problem
-- neosolarized :FIX: colorbuddy not working, colors are not in place.
-- solarized-osaka
-- xcode
-- xcodehc
local colorschemeName = "onedark"
Colorscheme_transparent = false

-- comments are not becoming italic. -> i think due to fonts.

local skip_configuration_for = { "xcode", "xcodehc" }
if not utils.has_value(skip_configuration_for, colorschemeName) then
	require("plugins.configs.colorschemes." .. colorschemeName)
end

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
