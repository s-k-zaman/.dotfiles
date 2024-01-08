return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "black",
        "isort",
      })
    end,
  },
  -- formatters and linters
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics

      opts.sources = opts.sources or {}

      -- python
      table.insert(opts.sources, formatting.black)
      table.insert(
        opts.sources,
        formatting.isort -- for sorting imports alphabetically
      )
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["python"] = { "black" },
      },
    },
  },
  -- lsp
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<leader>cr", false }
      -- lsp renaming
      if require("lazyvim.util").has("inc-rename.nvim") then
        keys[#keys + 1] = {
          "<leader>rn",
          function()
            local inc_rename = require("inc_rename")
            return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
          end,
          desc = "[R]e[n]ame (inc_rename)",
          expr = true,
          has = "rename",
        }
      else
        keys[#keys + 1] = {
          "<leader>rn",
          vim.lsp.buf.rename,
          desc = "[R]e[n]ame",
          expr = true,
          has = "rename",
        }
      end
    end,

    opts = {
      servers = {
        lua_ls = {
          -- enabled = false,
          single_file_support = true,
          settings = require("plugins.configs.LspServerSettings.lua_ls"),
        },
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        tsserver = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          single_file_support = false,
          settings = require("plugins.configs.LspServerSettings.tsserver"),
        },
        yamlls = {
          settings = require("plugins.configs.LspServerSettings.yamlls"),
        },
        pyright = {
          settings = require("plugins.configs.LspServerSettings.pyright"),
        },
        ruff_lsp = { enabled = false },
      },
    },
  },
  -- autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji", "hrsh7th/cmp-nvim-lua" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "nvim_lua" })
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
}
