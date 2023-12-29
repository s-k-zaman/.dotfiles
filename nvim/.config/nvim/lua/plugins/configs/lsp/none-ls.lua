local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local sources = {

	-- webdev stuff
	-- formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
	-- formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes
	formatting.prettier,
	diagnostics.eslint_d,

	-- Lua
	formatting.stylua,

	-- python
	-- diagnostics.mypy, -- for type checking in python.
	diagnostics.ruff,
	formatting.black,
	formatting.isort, -- for sorting imports alphabetically
}

null_ls.setup({
	debug = true,
	sources = sources,
})
