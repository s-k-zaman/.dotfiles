---@diagnostic disable: undefined-global
return {
    {
        "numToStr/Comment.nvim",
        -- enabled=false,
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
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        config = function(_, opts)
            local todo_comments = require("todo-comments")
            todo_comments.setup(opts)
            local map = require("utils.keymapper").keymap
            local keywords = { "TODO", "FIX", "FIXME" }

            -- stylua: ignore start
            map("n", "<leader>st", function() Snacks.picker.todo_comments() end, { desc = "Todo comments(all types)" })
            map("n", "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, { desc = "Todo/Fix/Fixme" })

            map("n", "]t", function() todo_comments.jump_next({ keywords = keywords }) end, { desc = "Next todo comment(buf)" })
            map("n", "[t", function() todo_comments.jump_prev({ keywords = keywords }) end, { desc = "Previous todo comment(buf)" })
            -- stylua: ignore end
        end,
    },
}
