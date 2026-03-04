return {
    {
        "windwp/nvim-ts-autotag",
        ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "astro", "vue" },
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false,
                },
                per_filetype = {
                    ["html"] = {
                        enable_close = true,
                    },
                },
            })
        end,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "windwp/nvim-autopairs",
        enabled = false,
        event = "InsertEnter",
        opts = {},
    },
    {
        "echasnovski/mini.surround",
        event = "BufEnter",
        opts = {
            custom_surroundings = nil,
            highlight_duration = 500,
            mappings = {
                add = "sa",
                delete = "sd",
                find = "sf",
                find_left = "sF",
                highlight = "sh",
                replace = "sr",
                update_n_lines = "sn",

                suffix_last = "l",
                suffix_next = "n",
            },
            n_lines = 20,
            respect_selection_type = false,
            search_method = "cover",
            silent = false,
        },
    },
}
