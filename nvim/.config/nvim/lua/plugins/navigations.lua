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
        dependencies = { "nvim-lua/plenary.nvim" },
        branch = "harpoon2",
        event = "BufReadPre",
        -- enabled = false,
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup({
                settings = {
                    save_on_toggle = false,
                },
            })
            map("n", "<leader>fa", function()
                harpoon:list():append()
            end, { desc = "harpoon: add this file" })
            map("n", "<C-b>", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "harpoon: toggle menu" })

            vim.keymap.set("n", "<C-o>", function()
                harpoon:list():select(1)
            end, { desc = "harpoon: file 1" })
            map("n", "<C-p>", function()
                harpoon:list():select(2)
            end, { desc = "harpoon: file 2" })
            map("n", "<C-f>", function()
                harpoon:list():select(3)
            end, { desc = "harpoon: file 3" })
            map("n", "<C-e>", function()
                harpoon:list():select(4)
            end, { desc = "harpoon: file 4" })
        end,
    },
}
