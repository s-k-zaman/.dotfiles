--------------- diagnostic, viwes -----------------
local opts = {
	diagnostics = {
		underline = true,
		update_in_insert = false,
		virtual_text = {
			spacing = 4,
			source = "if_many",
			--prefix = "●",
			-- prefix `icons` will set set the prefix to a function that returns the diagnostics icon based on the severity
			-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
			prefix = "icons",
		},
		severity_sort = true,
	},
}

for name, icon in pairs(require("utils.icons_lazynvim").icons.diagnostics) do
	name = "DiagnosticSign" .. name
	vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end
if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
	opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
		or function(diagnostic)
			local icons = require("utils.icons_lazynvim").icons.diagnostics
			for d, icon in pairs(icons) do
				if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
					return icon
				end
			end
		end
end
vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
