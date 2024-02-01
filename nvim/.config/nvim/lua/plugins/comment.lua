return {
    {
        "numToStr/Comment.nvim",
        lazy = false,
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
            },
        },
        config = function()
            vim.g.skip_ts_context_commentstring_module = true
            require("Comment").setup({
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })
        end,
    },
    {
        "folke/todo-comments.nvim",
        event = "BufReadPre",
        dependencies = { "nvim-lua/plenary.nvim" },
        -- TODO: add some commands accessing the lists
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
}
