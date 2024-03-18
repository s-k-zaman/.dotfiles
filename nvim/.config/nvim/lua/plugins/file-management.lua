return {
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        config = function()
            -- vim.keymap.set("n", "<C-e>", "<cmd>NvimTreeToggle<CR>", { noremap=true, silent=true, desc = "toggle file explorer" })
            -- TODO: smart locate file explorer using nvimtree apis.
            vim.keymap.set(
                "n",
                "<leader>e",
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
                    dotfiles = true,
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
        -- enabled = false,
        config = function()
            require("oil").setup()
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end,
    },
}
