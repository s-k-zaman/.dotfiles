return {
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle" },
		init = function()
			vim.keymap.set("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "toggle file explorer" })
		end,
		config = function()
			-- disable netrw at the very start of your init.lua (strongly advised)
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			vim.keymap.set("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "toggle file explorer" })

			local function my_on_attach(bufnr)
				local api = require("nvim-tree.api")
				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				-- use all default mappings
				api.config.mappings.default_on_attach(bufnr)

				-- remove a default mapping
				vim.keymap.del("n", "<tab>", { buffer = bufnr })
			end
			-- empty setup using defaults
			require("nvim-tree").setup({
				on_attach = my_on_attach,
				filters = {
					dotfiles = true,
				},
				disable_netrw = true,
				hijack_netrw = true,
				hijack_cursor = true,
				hijack_unnamed_buffer_when_opening = false,
				sync_root_with_cwd = true,
				update_focused_file = {
					enable = true,
					update_root = false,
				},
				view = {
					adaptive_size = false,
					side = "right",
					width = 38,
					preserve_window_proportions = true,
				},
				git = {
					enable = true,
				},
				filesystem_watchers = {
					enable = true,
				},
				actions = {
					open_file = {
						resize_window = true,
					},
				},
				renderer = {
					root_folder_label = false,
					highlight_opened_files = "none",
					group_empty = true,
					highlight_git = true,

					indent_markers = {
						enable = false,
					},

					icons = {
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
						},

						glyphs = {
							default = "󰈚",
							symlink = "",
							folder = {
								default = "",
								empty = "",
								empty_open = "",
								open = "",
								symlink = "",
								symlink_open = "",
								arrow_open = "",
								arrow_closed = "",
							},
							git = {
								unstaged = "✗",
								staged = "✓",
								unmerged = "",
								renamed = "➜",
								untracked = "★",
								deleted = "",
								ignored = "◌",
							},
						},
					},
				},
			})
		end,
	},
}
