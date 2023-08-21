local M = {}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
  filters = {
    dotfiles = true,
  },
}

M.mason = {
  formatters_linters_servers = {
    "prettier",
    "stylua",
    -- "deno",
    "ruff",
    "mypy",
    "black",
  },
  PATH = "skip",
  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = " 󰚌",
    },
  },
  max_concurrent_installers = 10,
}
return M
