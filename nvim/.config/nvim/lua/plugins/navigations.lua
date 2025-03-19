local map = require("utils.keymapper").keymap

return {
    -- window movement along with tmux.
    { "christoomey/vim-tmux-navigator", lazy = false },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        enabled = true,
        opts = {
            modes = {
                -- a regular search with `/` or `?`
                search = {
                    enabled = true,
                },
                -- `f`, `F`, `t`, `T`, `;` and `,` motions
                char = {
                    enabled = false,
                    highlight = { backdrop = false },
                },
            },
        },
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "BufReadPre",

        config = function()
            local harpoon = require("harpoon")

            -- REQUIRED
            harpoon:setup()
            -- REQUIRED

            -- stylua: ignore start
            map("n", "<leader>fa", function() harpoon:list():add() end, { desc = "harpoon: add this file" })
            map("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,{ desc = "harpoon: toggle menu" } )

            map("n", "<C-o>", function() harpoon:list():select(1) end, { desc = "harpoon: file 1" })
            map("n", "<C-p>", function() harpoon:list():select(2) end, { desc = "harpoon: file 2" })
            map("n", "<C-f>", function() harpoon:list():select(3) end, { desc = "harpoon: file 3" })
            map("n", "<C-e>", function() harpoon:list():select(4) end, { desc = "harpoon: file 4" })

            -- FIX: keymaps not working, spawning new terminal
            -- Toggle previous & next buffers stored within Harpoon list
            -- map("n", "<C-S-P>", function() harpoon:list():prev() end , { desc = "harpoon: prev file" })
            -- map("n", "<C-S-N>", function() harpoon:list():next() end , { desc = "harpoon: next file" })
            -- stylua: ignore end
        end,
    },
}
