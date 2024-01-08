return {
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {},
  },
  {
    -- window movement along with tmux.
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Go to the previous pane" },
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Got to the left pane" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Got to the down pane" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Got to the up pane" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Got to the right pane" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "right",
      },
    },
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },
  {
    "theprimeagen/harpoon", -- quick access tool
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "harpoon: add this file" })
      vim.keymap.set("n", "qq", ui.toggle_quick_menu, { desc = "harpoon: toggle menu" })
      vim.keymap.set("n", "<C-m>", function()
        ui.nav_file(1)
      end, { desc = "harpoon: file 1" })
      vim.keymap.set("n", "<C-n>", function()
        ui.nav_file(2)
      end, { desc = "harpoon: file 2" })
      vim.keymap.set("n", "<C-i>", function()
        ui.nav_file(3)
      end, { desc = "harpoon: file 3" })
      vim.keymap.set("n", "<C-o>", function()
        ui.nav_file(4)
      end, { desc = "harpoon: file 4" })
    end,
  },
  -- multi-cursor
  {
    -- TODO: know this plugin, very useful
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
  },
}
