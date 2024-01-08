-- bootstrappig lazy-nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- initiating settings, autocmds, keymaps....
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- starting lazy-nvim
local opts = require("plugins.configs.lazy-nvim") 
require("lazy").setup("plugins", opts)

-- initiating post-options[ie: after plugins load]
require("config.post-options")
require("plugins.configs.diagnostics")
