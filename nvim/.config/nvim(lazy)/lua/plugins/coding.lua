return {
  {
    "TabbyML/vim-tabby",
    enabled = false,
    event = { "BufEnter" },
    config = function()
      vim.g.tabby_trigger_mode = "auto" -- optinos are ['manual', 'auto']
      vim.g.tabby_keybinding_accept = "<C-y>"
      vim.g.tabby_keybinding_trigger_or_dismiss = "<C-\\>"
    end,
  },
  -- Incremental rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    config = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  -- Refactoring tool
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup()
    end,
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
        desc = "refactoring options",
      },
    },
    opts = {},
  },
}
