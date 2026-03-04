local suggestions = {
    accept = "<M-y>",
    next = "<M-n>",
    prev = "<M-p>",
    dismiss = "<M-c>",
}
return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            local opts = {
                suggestion = {
                    auto_trigger = false,
                    keymap = suggestions,
                },
            }
            require("copilot").setup(opts)

            -- keymaps
            vim.keymap.set(
                "n",
                "<leader>ct",
                require("copilot.suggestion").toggle_auto_trigger,
                { desc = "copilot: toggle suggestions" }
            )
        end,
    },
    {
        "NickvanDyke/opencode.nvim",
        lazy = false,
        dependencies = {
            { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
        },
        config = function()
            vim.g.opencode_opts = {}

            vim.o.autoread = true

            -- stylua: ignore start
            vim.keymap.set({ "n", "x" }, "<leader>at", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask about this" })
            vim.keymap.set({ "n", "x" }, "<leader>as", function() require("opencode").select() end, { desc = "Select prompt" })
            vim.keymap.set({ "n", "x" }, "<leader>a+", function() require("opencode").prompt("@this") end, { desc = "Add this" })
            vim.keymap.set("n", "<leader>aa", function() require("opencode").toggle() end, { desc = "Toggle embedded" })
            vim.keymap.set("n", "<leader>ac", function() require("opencode").command() end, { desc = "Select command" })
            vim.keymap.set("n", "<leader>an", function() require("opencode").command("session_new") end, { desc = "New session" })
            vim.keymap.set("n", "<leader>ai", function() require("opencode").command("session_interrupt") end, { desc = "Interrupt session" })
            vim.keymap.set("n", "<leader>am", function() require("opencode").command("agent_cycle") end, { desc = "Cycle selected agent" })
            vim.keymap.set("n", "<S-C-u>",    function() require("opencode").command("messages_half_page_up") end, { desc = "Messages half page up" })
            vim.keymap.set("n", "<S-C-d>",    function() require("opencode").command("messages_half_page_down") end, { desc = "Messages half page down" })
            -- stylua: ignore end
        end,
    },
}
