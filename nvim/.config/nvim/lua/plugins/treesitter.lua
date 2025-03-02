local config = function()
    require("nvim-treesitter.configs").setup({
        build = ":TSUpdate",
        indent = {
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
            "ron",
            "rust",
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
            -- additional_vim_regex_highlighting = true, -- causing problem in jsx/tsx files
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<S-h>",
                node_incremental = "<S-h>",
                scope_incremental = false,
                node_decremental = "<S-l>",
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
            -- nvim treesitter textobjects options
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    -- You can optionally set descriptions to the mappings (used in the desc parameter of
                    -- nvim_buf_set_keymap) which plugins like which-key display
                    -- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
                -- You can choose the select mode (default is charwise 'v')
                selection_modes = {
                    ["@parameter.outer"] = "v", -- charwise
                    ["@function.outer"] = "V", -- linewise
                    -- ["@class.outer"] = "<c-v>", -- blockwise
                },
                include_surrounding_whitespace = false,
            },
        },
    })
end

return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = config,
}
