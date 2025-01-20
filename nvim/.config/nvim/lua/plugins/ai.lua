return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            local opts = {
                suggestion = {
                    keymap = {
                        accept = "<M-y>",
                        next = "<M-n>",
                        prev = "<M-p>",
                        dismiss = "<M-c>",
                    },
                },
            }

            require("copilot").setup(opts)

            -- keymaps
            vim.keymap.set(
                "n",
                "<leader>cT",
                require("copilot.suggestion").toggle_auto_trigger,
                { desc = "copilot: toggle autotrigger" }
            )
        end,
    },
}
