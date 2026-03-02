return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            -- nvim-treesitter v1.0+ removed nvim-treesitter.configs and the module system.
            -- Highlighting is handled natively by neovim.
            -- Parser installation replaces the old ensure_installed option.
            require("nvim-treesitter.install").install({
                "bash",
                "c",
                "diff",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "ron",
                "rust",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
                "latex",
                "scss",
                "svelte",
                "typst",
                "vue",
            })
        end,
    },
}
