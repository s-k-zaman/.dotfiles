local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {
  --------------------------------------
  -- {
  --   "pacakage/name",
  --   ->configuration of the pacakage 👇🏻
  --   opts = overrides.treesitter,
  --           or/plus using
  --   config = function()
  --   ...
  --   require("pacakage_name").setup()
  --             or
  --   require "plugins.configs.file_name"
  --   require "custom.configs.file_name"
  --   ...
  --   end
  -- },
  --
  -- -------------------------------
  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- }
  -- -------------------------------
  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
  --------------------------------------
  -- LSP
  {
    "williamboman/mason.nvim",
    config = function()
      -- mason setup() is in lspconfig file. settings are in overrides file.
      -- copied from nvchad cmd to install all mason binaries other than lsp-servers.
      -- lsp servers are handled by mason-lspconfig.
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(overrides.mason.formatters_linters_servers, " "))
      end, {})
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
      {
        "hrsh7th/cmp-nvim-lsp",
      },
      { "williamboman/mason-lspconfig.nvim" },
      {
        "folke/neodev.nvim", -- Additional lua configuration, makes nvim stuff amazing!
      },
      {
        "stevearc/dressing.nvim", --nake dressings to vim.input
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require("custom.configs.treesitter").setup,
  },
  -- {
  -- "nvim-treesitter/playground" --enabled it to see how treesitter works...
  -- },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  {
    "theprimeagen/harpoon", --quick access tool
  },
  {
    "mbbill/undotree", -- TODO: know this plugin
    lazy = false,
  },
  {
    "tpope/vim-fugitive", -- TODO: know this plugin
  },
  {
    "folke/zen-mode.nvim", -- makes file in the center.
  },
  -- {
  -- "github/copilot.vim", --TODO: know this plugin
  -- }
  {
    "eandrju/cellular-automaton.nvim", --make it rain is used here.
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
}

return plugins
