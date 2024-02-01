local config = function()
    require("nvim-treesitter.configs").setup({
        build = ":TSUpdate",
        indent = {
            enable = true,
        },
        autotag = {
            enable = true,
        },
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        ensure_installed = {
            "bash",
            "c",
            "diff",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "jsonc",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
        },
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<leader>h",
                node_incremental = "<leader>h",
                scope_incremental = false,
                node_decremental = "<leader>j",
            },
        },
        textobjects = {
            swap = {
                enable = false,
                swap_next = {
                    ["<C-d>"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<C-u>"] = "@parameter.inner",
                },
            },
        },
    })
end

return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = config,
}
