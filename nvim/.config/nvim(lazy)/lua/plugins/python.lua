return {
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    keys = {
      { "<leader>cv", false },
      { "<F7>", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
  },
}
