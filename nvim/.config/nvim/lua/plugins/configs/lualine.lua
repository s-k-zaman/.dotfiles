-- require('lualine').setup(require('ui_modules.evil_lualine'))
local icons = require("utils.icons_lazynvim").icons

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		disabled_filetypes = {
			statusline = { "dashboard", "alpha" },
			winbar = {},
		},
		icons_enabled = true,
		component_separators = {
			-- left = "",
			-- right = "",
			left = "",
			right = "",
		},

		section_separators = {
			-- left = "",
			-- right = "",
			left = "",
			right = "",
		},
		ignore_focus = {},
		always_divide_middle = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		-- left sections
		lualine_a = { "mode" },
		lualine_b = {
			"branch",
		},
		lualine_c = {

			-- "diff",
			{
				"diagnostics",
				symbols = {
					error = icons.diagnostics.Error,
					warn = icons.diagnostics.Warn,
					info = icons.diagnostics.Info,
					hint = icons.diagnostics.Hint,
				},
			},
			-- { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{ "filename", path = 0, symbols = { modified = "󰛓", readonly = "", unnamed = "" } },
			-- for nvim-navic
			-- stylua: ignore
			-- {
			--   function() return require("nvim-navic").get_location() end,
			--   cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
			-- },
			{
				function()
					return require("modules.ui").python_venv(false, false)
				end,
			},
		},
		-- right sections
		lualine_x = {
			{
				function()
					return require("modules.ui.lsp-info").get_lsps()
				end,
			},
			{ "filetype", icon = { align = "right" } },
			"encoding",
			{
				"diff",
				symbols = {
					added = icons.git.added,
					modified = icons.git.modified,
					removed = icons.git.removed,
				},
			},
		},
		lualine_y = {
			{ "progress", separator = " ", padding = { left = 1, right = 0 } },
			{ "location", padding = { left = 0, right = 1 } },
		},
		lualine_z = {
			function()
				return " " .. os.date("%I:%M, %a")
			end,
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = { "nerdtree", "lazy" },
})
