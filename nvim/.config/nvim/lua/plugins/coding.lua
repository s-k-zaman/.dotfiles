return {
  {
    "TabbyML/vim-tabby",
    -- enabled = false,
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
}
