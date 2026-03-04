local tailwind_fts = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" }

return {
    { "roobert/tailwindcss-colorizer-cmp.nvim", ft = tailwind_fts, config = true },
    {
        "luckasRanarison/tailwind-tools.nvim",
        name = "tailwind-tools",
        ft = tailwind_fts,
        build = ":UpdateRemotePlugins",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "neovim/nvim-lspconfig",
        },
        opts = {
            cmp = {
                highlight = "background",
            },
            server = {
                override = not CONFIG_TAILWIND_IN_LSPCONFIG,
                settings = {
                    classAttributes = { "classNames" },
                },
            },
            extension = {
                queries = { "css", "scss", "xhtml" },
            },
        },
    },
}
