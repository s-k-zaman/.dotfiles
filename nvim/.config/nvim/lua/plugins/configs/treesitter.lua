local opts = {
	-- A list of parser names, or "all"
	ensure_installed = {
		"javascript", -- 'help', -> causing problem[its a bug]
        "json",
		"typescript",
		"tsx",
		"python",
		"vim",
		"lua",
	},
	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,
	context_commentstring = {
		enable = true,
	},
	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
		disable = { "python" },
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<C-q>",
		},
	},
	textobjects = {
		select = {
			enable = false,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = false,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<C-d>"] = "@parameter.inner",
			},
			swap_previous = {
				["<C-u>"] = "@parameter.inner",
			},
		},
	},
}
require("nvim-treesitter.configs").setup(opts)

-- dont know what it does but copied from lazynvim
if load_textobjects then
	-- PERF: no need to load the plugin, if we only need its queries for mini.ai
	if opts.textobjects then
		for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
			if opts.textobjects[mod] and opts.textobjects[mod].enable then
				local Loader = require("lazy.core.loader")
				Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
				local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
				require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
				break
			end
		end
	end
end
