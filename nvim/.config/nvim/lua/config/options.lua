-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false

vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
-- vim.opt.shiftwidth = 4
vim.opt.scrolloff = 8
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.spell = true
vim.opt.showcmd = true
-- vim.opt.winbar = "%=%m %f" -- shows filename in top right corner

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
