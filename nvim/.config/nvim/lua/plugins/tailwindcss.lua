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
        opts = { -- your configuration
            cmp = {
                highlight = "background", -- color preview style, "foreground" | "background"
            },
            server = {
                override = not CONFIG_TAILWIND_IN_LSPCONFIG,
                settings = {
                    classAttributes = { "classNames" },
                    -- experimental = {
                    --     classRegex = {
                    --         "classNames\\(([^)]*)\\)", -- For classNames function pattern
                    --     },
                    -- },
                },
            },
            extension = {
                queries = { "css", "scss" },
            },
        },
    },
}
