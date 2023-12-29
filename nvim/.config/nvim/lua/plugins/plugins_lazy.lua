-- build: runs on install or update.
-- cmd: will lazy load this plugin on this command/acceble through this command other wise inactive.
-- opts: should be a table (will be merged with parent specs), return a table (replaces parent specs) or
--          should change a table. The table will be passed to the config() function.
--           Setting this value will imply config()
-- config: configuration file/do configuration inside a function.
--          config is executed when the plugin loads.
--          To use the default implementation without opts set config to `true`.
-- init: init functions are always executed during startup

local plugins = {
	{ "nvim-lua/plenary.nvim" },
	{
		"nvim-tree/nvim-web-devicons",
		opts = {},
	},
	-- colorschemes
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
	-- colorschemes ends

	{
		"nvim-treesitter/nvim-treesitter",
		cmd = { "TSInstall", "TSBufEnable" },
		build = ":TSUpdate",
		config = function()
			require("plugins.configs.treesitter")
		end,
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				lazy = true,
				init = function()
					vim.g.skip_ts_context_commentstring_module = true
				end,
				config = function()
					require("ts_context_commentstring").setup({})
				end,
			},
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					-- disable rtp plugin, as we only need its queries for mini.ai
					-- In case other textobject modules are enabled, we will load them
					-- once nvim-treesitter is loaded
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
					load_textobjects = true
				end,
			},
		},
	},
	-- auto-completes and Snippets
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets", -- adds many extra snippets.
				config = function()
					require("plugins.configs.lsp.luasnip")
				end,
			},
			{
				"roobert/tailwindcss-colorizer-cmp.nvim",
				config = function()
					require("plugins.configs.lsp.tailwind-colorizer")
				end,
			},
			-- cmp sources plugins
			{
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
		},
		config = function()
			require("plugins.configs.lsp.nvim_cmp")
		end,
	},
	-- LSP
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll" },
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufEnter", "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"folke/neodev.nvim", -- Additional lua configuration, makes nvim stuff amazing!
			},
			{
				"nvimtools/none-ls.nvim",
				config = function()
					require("plugins.configs.lsp.none-ls")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" },
		},
		init = function()
			require("utils.lazy_nvim").lazy_load("nvim-lspconfig")
		end,
		config = function()
			require("plugins.configs.lsp.lspconfig")
		end,
	},
	{ "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
	-- Mini.ai: many plugins together
	{
		"echasnovski/mini.nvim",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("plugins.configs.mini-ai")
			require("plugins.configs.mini-comment")
			require("plugins.configs.mini-surround")
			-- autopairs
			require("plugins.configs.mini-pairs")
		end,
	},
	{
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = { "BufReadPre", "BufNewFile" },
		opts = require("plugins.configs.mini-indentscope"),
		init = function()
			require("autocmds.mini-indentscope")
		end,
	},
	-- Mini.ai ends
	-- window movement along with tmux.
	{ "christoomey/vim-tmux-navigator", lazy = false },
	-- file management and searching.
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle" },
		config = function()
			require("plugins.configs.nvimtree")
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		cmd = "Telescope",
		config = function()
			require("plugins.configs.telescope")
		end,
	},
	-- Diagnostics
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = require("mappings.trouble"),
	},
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		config = true,
		keys = require("mappings.todo-comments"),
	},
	-- search and replace
	{
		"nvim-pack/nvim-spectre",
		cmd = "Spectre",
		opts = { open_cmd = "noswapfile vnew" },
	},
	-- other plugins
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		vscode = true,
		---@type Flash.Config
		opts = {},
		keys = require("mappings.flash"),
	},
	{
		"stevearc/dressing.nvim", -- make dressings to vim.input
		init = function()
			require("plugins.configs.dressing")
		end,
	},
	{
		-- highlights matched words
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("plugins.configs.vim-illuminate")
			require("mappings.vim-illuminate")
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		init = function()
			require("utils.lazy_nvim").lazy_load("nvim-colorizer.lua")
		end,
		config = function()
			require("plugins.configs.nvim-colorizer")
		end,
	},
	{
		"theprimeagen/harpoon", -- quick access tool
		init = function()
			require("utils.lazy_nvim").lazy_load("harpoon")
		end,
		config = function()
			require("mappings.harpoon")
		end,
	},
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},
	{
		"tpope/vim-fugitive", -- TODO: know this plugin
		event = { "VeryLazy" },
	},
	{
		"folke/zen-mode.nvim",
		event = { "VeryLazy" },
	},
	-- lines/bars/tabs
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		-- gives location tree inside a functions/class/structure.
		"SmiteshP/nvim-navic",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},
	-- session managers
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
		keys = require("mappings.persistence"),
	},
	-- for keymappings
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
}

return plugins
