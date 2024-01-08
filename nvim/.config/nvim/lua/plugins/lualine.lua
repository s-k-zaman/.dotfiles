return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local icons = require("utils.glyphs").icons
			require("lualine").setup({
				options = {
					theme = "auto",
					globalstatus = true,
					disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
					component_separators = {
						left = "",
						right = "",
					},
					section_separators = {
						left = "",
						right = "",
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
						{
							"filename",
							path = 1,
							symbols = { modified = "󰛓", readonly = "", unnamed = "[No Name]" },
						},
						-- for nvim-navic
						-- sstylua: ignore
						-- {
						--   function() return require("nvim-navic").get_location() end,
						--   cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
						-- },

						{
							function()
								return require("modules.ui").python_venv(false, false)
							end,
						},
						{
							function()
								return require("modules.ui").python_venv_selector(false, false)
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
			})
		end,
	},
	{
		-- gives location tree inside a functions/class/structure.
		"SmiteshP/nvim-navic",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},
}
