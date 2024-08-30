return {
    { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    {
        "luckasRanarison/tailwind-tools.nvim",
        name = "tailwind-tools",
        lazy = false,
        build = ":UpdateRemotePlugins",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- optional
            "neovim/nvim-lspconfig", -- optional
        },
        opts = {}, -- your configuration
    },
}
