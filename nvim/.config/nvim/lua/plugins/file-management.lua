local map = require("utils.keymapper").keymap
return {
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        config = function()
            -- vim.keymap.set("n", "<C-e>", "<cmd>NvimTreeToggle<CR>", { noremap=true, silent=true, desc = "toggle file explorer" })
            -- TODO: smart locate file explorer using nvimtree apis.
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
                -- use all default mappings
                api.config.mappings.default_on_attach(bufnr)
                -- remove a default mapping
                vim.keymap.del("n", "<tab>", { buffer = bufnr })
            end
            -- empty setup using defaults
            require("nvim-tree").setup({
                on_attach = my_on_attach,
                filters = {
                    -- dotfiles = true,
                    git_ignored = false,
                    custom = {
                        -- exclude these
                        -- "node_modules",
                    },
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
                git = {
                    enable = true,
                },
                filesystem_watchers = {
                    enable = true,
                },
                actions = {
                    open_file = {
                        resize_window = true,
                    },
                },
            })
        end,
    },
    {
        "stevearc/oil.nvim",
        lazy = false,
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            ---@module 'oil'
            ---@type oil.SetupOpts
            local opts = {}
            require("oil").setup()
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
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
            map("n", "<C-m>", function() harpoon:list():select(3) end, { desc = "harpoon: file 3" })
            map("n", "<C-p>", function() harpoon:list():select(4) end, { desc = "harpoon: file 4" })
            -- stylua: ignore end
        end,
    },
}
