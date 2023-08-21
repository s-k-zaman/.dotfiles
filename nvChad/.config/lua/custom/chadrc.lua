---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "onedark",
  theme_toggle = { "onedark", "chocolate" },
  transparency = true,

  hl_override = highlights.override,
  hl_add = highlights.add,
  statusline = {
    theme = "default",
    separator_style = "arrow",
    overriden_modules = function(modules)
      modules[8] = (function()
        if rawget(vim, "lsp") then
          for _, client in ipairs(vim.lsp.get_active_clients()) do
            if client.attached_buffers[vim.api.nvim_get_current_buf()] and client.name ~= "null-ls" then
              return (vim.o.columns > 100 and "%#St_LspStatus#" .. "   LSP ~ " .. client.name .. " ") or "   LSP "
            end
          end
        end
      end)()
      table.insert(
        modules,
        4,
        (function()
          return require("custom.ui_modules").python_venv(false, false)
        end)()
      )
    end,
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
