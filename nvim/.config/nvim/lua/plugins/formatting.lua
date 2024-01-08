local PluginUtils = require("utils.plugins")

------ :Format command --------
local function format(bufnr)
	if PluginUtils.has("conform.nvim") then
		require("conform").format({ bufnr = bufnr, lsp_fallback = true })
		return
	end
	vim.lsp.buf.format()
end
vim.api.nvim_create_user_command("Format", function(args)
	format(args.buf)
end, {
	desc = "Format command (conform|lsp)",
})
-- Auto Formatting
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat or not vim.g.autoformat then
			return
		end
		format(args.buf)
	end,
})

return {
	{
		"stevearc/conform.nvim",
		-- enabled = false,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		cmd = "ConformInfo",
		opts = function()
			---@class ConformOpts
			local opts = {
				format = {
					timeout_ms = 3000,
					async = false, -- not recommended to change
					quiet = false, -- not recommended to change
				},
				formatters_by_ft = {
					lua = { "stylua" },
					fish = { "fish_indent" },
					sh = { "shfmt" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					vue = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },
					less = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					jsonc = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					["markdown.mdx"] = { "prettier" },
					graphql = { "prettier" },
					handlebars = { "prettier" },
					python = { "black", "isort" },
				},
				-- The options you set here will be merged with the builtin formatters.
				-- You can also define any custom formatters here.
				formatters = {
					injected = { options = { ignore_errors = true } },
					-- # Example of using dprint only when a dprint.json file is present
					-- dprint = {
					--   condition = function(ctx)
					--     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
					--   end,
					-- },
					--
					-- # Example of using shfmt with extra args
					-- shfmt = {
					--   prepend_args = { "-i", "2", "-ci" },
					-- },
				},
			}
			return opts
		end,
		config = function(_, opts)
			require("conform").setup(opts)
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		-- enabled = false,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local null_ls = require("null-ls")
			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics
			local sources = {
				-- Webdev Stuff
				-- formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
				-- formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes
				formatting.prettier,
				-- Lua
				formatting.stylua,
				-- Python
				-- diagnostics.mypy, -- for type checking in python.
				formatting.black,
				formatting.isort, -- for sorting imports alphabetically
			}
			null_ls.setup({
				debug = true,
				sources = sources,
			})
		end,
	},
}
