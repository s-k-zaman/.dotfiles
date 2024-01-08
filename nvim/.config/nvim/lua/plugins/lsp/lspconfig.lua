local PluginUtil = require("utils.plugins")

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = require("plugins.lsp.lsp_mappings").on_attach

if PluginUtil.has("neoconf.nvim") then
	local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
	require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
end

-- add any global capabilities here
local additionl_capabilities = {}

local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
	"force",
	{},
	vim.lsp.protocol.make_client_capabilities(),
	has_cmp and cmp_nvim_lsp.default_capabilities() or {},
	additionl_capabilities or {}
)

-- Ensure the servers below are installed
local server_settings = {
	-- clangd = {},
	-- html = {},
	-- cssls = {},
	-- gopls = {},
	-- rust_analyzer = {},
	-- denols = {},
	eslint = require("plugins.lsp.LspServerSettings.eslint"),
	tsserver = require("plugins.lsp.LspServerSettings.tsserver"),
	yamlls = require("plugins.lsp.LspServerSettings.yamlls"),
	pyright = require("plugins.lsp.LspServerSettings.pyright"),
	lua_ls = require("plugins.lsp.LspServerSettings.lua_ls"),
}

------ Manage LSP server using mason_lspconfig -----
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

-- looping through all the servers by setup_handlers and setting the lsp.
mason_lspconfig.setup_handlers({
	-- TODO: make better server handling
	function(server_name)
		-- conditional settings can be done using server_name(eg: pyright, tsserver etc.)
		-- remember to use if-else or return statement while using if statement.
		if server_name == "ruff_lsp" then
			lspconfig[server_name].setup({
				enabled = false,
				capabilities = capabilities,
				on_attach = on_attach,
				settings = server_settings[server_name] or {},
			})
			return
		end
		if server_name == "tailwindcss" then
			lspconfig[server_name].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = server_settings[server_name] or {},
				root_dir = function(...)
					return require("lspconfig.util").root_pattern(".git")(...)
				end,
			})
			return
		end
		if server_name == "lua_ls" then
			lspconfig[server_name].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = server_settings[server_name] or {},
				single_file_support = true,
			})
			return
		end
		if server_name == "tsserver" then
			lspconfig[server_name].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = server_settings[server_name] or {},
				root_dir = function(...)
					return require("lspconfig.util").root_pattern(".git")(...)
				end,
				single_file_support = false,
			})
			return
		end
		if server_name == "tailwindcss" then
			local tw = require("lspconfig.server_configurations.tailwindcss")
			local filetypes = {}
			local filetypes_exclude = { "markdown" }
			vim.list_extend(filetypes, tw.default_config.filetypes)
			-- Remove excluded filetypes
			filetypes = vim.tbl_filter(function(ft)
				return not vim.tbl_contains(filetypes_exclude or {}, ft)
			end, filetypes)

			lspconfig[server_name].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = server_settings[server_name] or {},
				filetypes = filetypes,
			})
			return
		end
		lspconfig[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = server_settings[server_name] or {},
		})
	end,
})

-- INFO: there is a way to proiratize servers while conflicting
-- refer to lazy-vnim: https://github.com/LazyVim/LazyVim/ (in lua/lsp/init.lua file)
-- in config of nvim-lspconfig table
