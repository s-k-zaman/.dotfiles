-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

return require('lazy').setup({
    -- LSP
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'folke/neodev.nvim', -- Additional lua configuration, makes nvim stuff amazing!
        }
    },
    -- Autocompletion plugin
    { 'hrsh7th/nvim-cmp', --completion engine written in lua
        dependencies = {
            'hrsh7th/cmp-buffer', --buffer completions.
            'hrsh7th/cmp-path', --path completions.
            'hrsh7th/cmp-nvim-lsp', --additional complitions.
            --'hrsh7th/cmp-nvim-lua', --TODO: know use of this

            -- Snippets completions
            'L3MON4D3/LuaSnip', --snippet engine written in lua
            'saadparwaiz1/cmp_luasnip', --snippets completions
            'rafamadriz/friendly-snippets', --snippet collection
        },
    },
    {
        'nvim-telescope/telescope.nvim', version = '*',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    -- COLORSCHEMES
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    },
    'navarasu/onedark.nvim',
    -- colorscheme ends

    {
        'nvim-treesitter/nvim-treesitter', --treesitter.[very important]
        build = ':TSUpdate',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter-textobjects' }
        }
    },
    'nvim-treesitter/playground',
    'theprimeagen/harpoon', --quick access tool
    'mbbill/undotree', -- TODO: know this plugin
    'tpope/vim-fugitive', -- TODO: know this plugin
    {
        'nvim-tree/nvim-tree.lua', --nvim tree [file explorer]
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        }
    },
    -- 'nvim-lualine/lualine.nvim', --TODO: know this plugin
    -- 'numToStr/Comment.nvim',--TODO: know this plugin
    "folke/zen-mode.nvim", -- makes file in the center.
    -- "github/copilot.vim", --TODO: know this plugin
    "eandrju/cellular-automaton.nvim", --make it rain is used here.
}, {})
