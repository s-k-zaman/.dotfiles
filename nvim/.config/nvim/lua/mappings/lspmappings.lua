-- Loaded through plugin configuration
--
-- naviac setup here
local naviac = require("nvim-navic")
naviac.setup({
	separator = " ",
	highlight = true,
	depth_limit = 5,
	icons = require("utils.icons_lazynvim").icons.kinds,
})

local M = {}
M.on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
	if client.server_capabilities.documentSymbolProvider then
		naviac.attach(client, bufnr) -- attcing naviac.
	end

	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, {
			buffer = bufnr,
			desc = desc,
		})
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	-- symbols using telescope
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument/current buffer [S]ymbols") --
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols") --
	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<leader>K", vim.lsp.buf.signature_help, "Signature Documentation")
	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace: [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace: [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace: [L]ist Folders")
	-- following commands are copied from thePrimegeanYT.
	vim.keymap.set("n", "<leader>hh", function()
		vim.diagnostic.open_float()
	end, {
		desc = "view Floating(Hover) diagnostic/problem",
	})
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_next()
	end, {
		desc = "Goto prev diagnostic.",
	})
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_prev()
	end, {
		desc = "Goto next diagnostic",
	})
end
------- Formattings ----------
-- Create a command `:Format` local to the LSP buffer
vim.api.nvim_create_user_command("Format", function(_)
	vim.lsp.buf.format()
end, {
	desc = "Format current buffer with LSP",
})
-- auto formattting options
local autoformat = false

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("LspFormat", {}),
	callback = function()
		if autoformat then
			vim.lsp.buf.format()
		end
	end,
})
return M
