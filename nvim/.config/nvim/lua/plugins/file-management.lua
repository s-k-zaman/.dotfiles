local map = require("utils.keymapper").keymap
return {
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        config = function()
            vim.keymap.set(
                "n",
                "<leader>L",
                "<cmd>NvimTreeToggle<CR>",
                { noremap = true, silent = true, desc = "toggle file explorer" }
            )

            local function my_on_attach(bufnr)
                local api = require("nvim-tree.api")
                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end
                api.config.mappings.default_on_attach(bufnr)
                vim.keymap.del("n", "<tab>", { buffer = bufnr })
            end

            require("nvim-tree").setup({
                on_attach = my_on_attach,
                filters = {
                    git_ignored = false,
                    custom = {},
                },
                view = {
                    adaptive_size = false,
                    side = "right",
                    width = 38,
                    preserve_window_proportions = true,
                },
                update_focused_file = {
                    enable = true,
                    update_root = false,
                },
                git = { enable = true },
                filesystem_watchers = { enable = true },
                actions = {
                    open_file = { resize_window = true },
                },
            })
        end,
    },
    {
        "stevearc/oil.nvim",
        cmd = "Oil",
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup()
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "BufReadPre",

        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            -- stylua: ignore start
            map("n", "<leader>fa", function() harpoon:list():add() end, { desc = "harpoon: add this file" })
            map("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,{ desc = "harpoon: toggle menu" } )

            map("n", "<C-;>", function() harpoon:list():select(1) end, { desc = "harpoon: file 1" })
            map("n", "<C-'>", function() harpoon:list():select(2) end, { desc = "harpoon: file 2" })
            map("n", "<C-.>", function() harpoon:list():select(3) end, { desc = "harpoon: file 3" })
            map("n", "<C-p>", function() harpoon:list():select(4) end, { desc = "harpoon: file 4" })
            -- stylua: ignore end
        end,
    },
}
