-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -- OTHER PLUGINS
    -- LSP
    use {
        'neovim/nvim-lspconfig',
        requires = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'folke/neodev.nvim', -- Additional lua configuration, makes nvim stuff amazing!
        }
    }
    -- Autocompletion plugin
    use { 'hrsh7th/nvim-cmp', --completion engine written in lua
        requires = {
            'hrsh7th/cmp-buffer', --buffer completions.
            'hrsh7th/cmp-path', --path completions.
            'hrsh7th/cmp-nvim-lsp', --additional complitions.
            --'hrsh7th/cmp-nvim-lua', --TODO: know use of this

            -- Snippets completions
            'L3MON4D3/LuaSnip', --snippet engine written in lua
            'saadparwaiz1/cmp_luasnip', --snippets completions
            'rafamadriz/friendly-snippets', --snippet collection
        }
    }
    use {
        'nvim-telescope/telescope.nvim', version = '*',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    -- COLORSCHEMES
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })
    use 'navarasu/onedark.nvim'
    -- colorscheme ends

    use({
        'nvim-treesitter/nvim-treesitter', --treesitter.[very important]
        run = ':TSUpdate',
        requires = {
            { 'nvim-treesitter/nvim-treesitter-textobjects' }
        }
    })
    use('nvim-treesitter/playground')
    use('theprimeagen/harpoon') --quick access tool
    use('mbbill/undotree') -- TODO: know this plugin
    use('tpope/vim-fugitive') -- TODO: know this plugin
    use {
        'nvim-tree/nvim-tree.lua', --nvim tree [file explorer]
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        }
    }
    --use 'nvim-lualine/lualine.nvim' --TODO: know this plugin
    --use 'numToStr/Comment.nvim'--TODO: know this plugin
    use("folke/zen-mode.nvim") -- makes file in the center.
    --use("github/copilot.vim")--TODO: know this plugin
    use("eandrju/cellular-automaton.nvim") --make it rain is used here.
end)
