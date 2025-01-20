local Utils = require("utils")
return {
    {
        "tpope/vim-fugitive",
        -- INFO: either use this or use lazygit
        enabled = not USE_LAZYGIT,
        event = { "VeryLazy" },
        config = function()
            local augroup = require("utils").augroup

            vim.api.nvim_create_autocmd("BufWinEnter", {
                group = augroup("fugitive"),
                pattern = "*",
                callback = function()
                    -- if vim.bo.ft ~= "fugitive" then
                    -- if vim.api.nvim_command_output("!git rev-parse --is-inside-work-tree") ~= "true" then
                    --     return
                    -- end
                    if not Utils.is_git_repository() then
                        return
                    end
                    local bufnr = vim.api.nvim_get_current_buf()

                    vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "fugitive: git status" })

                    vim.keymap.set("n", "<leader>gp", function()
                        vim.cmd.Git("push")
                    end, { buffer = bufnr, remap = false, desc = "fugitive: git push" })
                    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                    -- needed if i did not set the branch up correctly
                    vim.keymap.set(
                        "n",
                        "<leader>gP",
                        ":Git push -u origin",
                        { buffer = bufnr, remap = false, desc = "fugitive: git push[-u origin]" }
                    )

                    -- rebase always
                    vim.keymap.set(
                        "n",
                        "<leader>gr",
                        ":Git pull --rebase<CR>",
                        { buffer = bufnr, remap = false, desc = "fugitive: git pull[rebase]" }
                    )
                end,
            })
        end,
    },
    {
        -- TODO: start using this plugin
        "lewis6991/gitsigns.nvim",
        event = { "VeryLazy" },
        -- enabled = false,
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "" },
                    topdelete = { text = "" },
                    changedelete = { text = "▎" },
                    untracked = { text = "▎" },
                },
                current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    delay = 500,
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end
                    map("n", "<leader>gh", gs.preview_hunk, { desc = "gitsigns: preview hunk" })
                    map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "gitsigns: toggle blame toggle" })
                end,
            })
        end,
    },
}
