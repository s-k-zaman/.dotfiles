--  This function gets run when an LSP connects to a particular buffer.
local on_attach = require("mappings.lspmappings").on_attach

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSuppot = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = {
		valueSet = { 1 },
	},
	resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	},
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
-- so that auto-suggestion-from LSP appers on cmp-nvim.
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers below are installed
local servers_list = {
	-- clangd = {},
	-- html = {},
	-- cssls = {},
	-- gopls = {},
	-- rust_analyzer = {},
	-- javascrip servers...
	-- denols = {},
	tsserver = {},
	-- python servers..
	pyright = require("plugins.configs.lsp.LspServerSettings.pyright"),
	-- lua servers ...
	lua_ls = require("plugins.configs.lsp.LspServerSettings.lua_ls"),
}

---------------------Adding Mason (order is important) -----------------------
-- Setup mason so it can manage external tooling
require("mason").setup(require("plugins.configs.lsp.mason"))

-- other formatters to instlal for none-ls[null-ls fork] with :MasonInstallAll command
local formatters_linters_servers = {
	"prettier",
	"eslint_d",
	"stylua", -- "deno",
	"ruff",
	"pyright",
	"mypy",
	"black",
	"isort",
}

vim.api.nvim_create_user_command("MasonInstallAll", function()
	vim.cmd("MasonInstall " .. table.concat(formatters_linters_servers, " "))
end, {})

vim.g.mason_binaries_list = formatters_linters_servers
------------------------------------------------------------------------------

-- TODO: check what is does.
require("neodev").setup()

------ Manage LSP server using mason_lspconfig -----
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers_list),
	automatic_installation = true,
})

-- looping through all the servers by setup_handlers.
mason_lspconfig.setup_handlers({
	function(server_name)
		if server_name == "pyright" then -- Pyright or other python LSPs
			lspconfig[server_name].setup({
				-- before_init = function(_, config)
				-- 	-- to auto enable venv
				-- 	local venv_selector_python = require("modules.venv_selector_python")
				-- 	-- check venv to enable status chosen by user
				-- 	if venv_selector_python.get_venv_status() ~= true then
				-- 		-- fallback to system path
				-- 		config.settings.python.pythonPath = vim.fn.exepath("python3")
				-- 			or vim.fn.exepath("python")
				-- 			or "python"
				-- 		return
				-- 	end
				-- 	-- Use activated virtualenv.
				-- 	if vim.env.VIRTUAL_ENV then
				-- 		config.settings.python.pythonPath = path.join(vim.env.VIRTUAL_ENV, "bin", "python")
				-- 	else
				-- 		-- if no activeated Virtual_Env, auto setting in folder venv
				-- 		local venv = venv_selector_python.try_set_in_folder_venv()
				-- 		if venv ~= false or venv ~= nil then
				-- 			config.settings.python.pythonPath = venv.python_path
				-- 		else
				-- 			-- if fails then,
				-- 			-- reset current venv, if present
				-- 			if venv_selector_python.get_current_venv() ~= nil then
				-- 				venv_selector_python.set_current_venv(nil)
				-- 			end
				-- 		end
				-- 	end
				-- end,
				capabilities = capabilities,
				on_attach = on_attach,
				settings = servers_list[server_name],
			})
		else -- other servers
			lspconfig[server_name].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = servers_list[server_name],
			})
		end
	end,
})
