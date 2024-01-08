return {
	Lua = {
		format = {
			enable = true,
			defaultConfig = {
				indent_style = "space",
				indent_size = "4",
				continuation_indent_size = "4",
			},
		},
		telemetry = {
			enable = false,
		},
		diagnostics = {
			-- enable = false,
			globals = { "vim", "path" },
			disable = { "incomplete-signature-doc", "trailing-space" },
			groupSeverity = {
				strong = "Warning",
				strict = "Warning",
			},
			groupFileStatus = {
				["ambiguity"] = "Opened",
				["await"] = "Opened",
				["codestyle"] = "None",
				["duplicate"] = "Opened",
				["global"] = "Opened",
				["luadoc"] = "Opened",
				["redefined"] = "Opened",
				["strict"] = "Opened",
				--["strong"] = "Opened",
				["type-check"] = "Opened",
				["unbalanced"] = "Opened",
				["unused"] = "Opened",
			},
			unusedLocalExclude = { "_*" },
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
		hint = {
			enable = true,
			setType = false,
			paramType = false,
			paramName = "Disable",
			semicolon = "Disable",
			arrayIndex = "Disable",
		},
		type = {
			castNumberToInteger = true,
		},
	},
}
