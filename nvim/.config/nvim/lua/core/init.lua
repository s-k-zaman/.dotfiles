-- bootstrappig lazy-nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- starting lazy-nvim
local opts = require("core.lazy-nvim-config")
require("lazy").setup(opts)

-- initiating post-options[ie: after plugins load]
require("core.post-options")
