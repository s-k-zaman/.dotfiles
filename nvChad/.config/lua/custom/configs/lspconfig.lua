local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local overrides = require "custom.configs.overrides"

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"
local path = util.path

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
  pyright = require "custom.lspLangServerSettings.pyright",
  -- lua servers ...
  lua_ls = require "custom.lspLangServerSettings.lua_ls",
}

-- mason SETUP
-- Setup mason so it can manage external tooling
require("mason").setup(overrides.mason)

-- Setup neovim lua configuration
require("neodev").setup()
-- Manage LSP server using mason_lspconfig.
local mason_lspconfig = require "mason-lspconfig"

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers_list),
  automatic_installation = true,
}

-- require("custom.utils.python").set_venv_current_workspace() --working for /venv folder
-- looping through all the servers by setup_handlers.
mason_lspconfig.setup_handlers {
  function(server_name)
    if server_name == "pyright" then -- Pyright or other python LSPs
      lspconfig[server_name].setup {
        before_init = function(_, config)
          local venv_selector_python = require "custom.modules.venv_selector_python"
          -- check venv to enable status chosen by user
          if venv_selector_python.get_venv_status() ~= true then
            -- fallback to system path
            config.settings.python.pythonPath = vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
            return
          end
          -- Use activated virtualenv.
          if vim.env.VIRTUAL_ENV then
            config.settings.python.pythonPath = path.join(vim.env.VIRTUAL_ENV, "bin", "python")
          else
            -- if no activeated Virtual_Env, auto setting in folder venv
            local venv = venv_selector_python.try_set_in_folder_venv()
            if venv ~= false or venv ~= nil then
              config.settings.python.pythonPath = venv.python_path
            else
              -- if fails then,
              --reset current venv, if present
              if venv_selector_python.get_current_venv() ~= nil then
                venv_selector_python.set_current_venv(nil)
              end
            end
          end
        end,
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers_list[server_name],
      }
    else
      lspconfig[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers_list[server_name],
      }
    end
  end,
}

--know what the following line does???
vim.diagnostic.config {
  virtual_text = true,
  -- signs = true,
}
