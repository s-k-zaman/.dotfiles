return {
	Lua = {
		telemetry = {
			enable = false,
		},
		diagnostics = {
			globals = { "vim", "path" },
		},
		workspace = {
			checkThirdParty = false,
			library = {
				[vim.fn.expand("$VIMRUNTIME/lua")] = true,
				[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
			},
			maxPreload = 100000,
			preloadFileSize = 10000,
		},
	},
}
