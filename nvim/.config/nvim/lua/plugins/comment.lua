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

            map("n", "<leader>ft", "TodoTelescope", { desc = "[F]ind all [T]odos Telescope" })

            map("n", "]t", function()
                todo_comments.jump_next({ keywords = keywords })
            end, { desc = "Next todo comment(file)" })

            map("n", "[t", function()
                todo_comments.jump_prev({ keywords = keywords })
            end, { desc = "Previous todo comment(file)" })
        end,
    },
}
