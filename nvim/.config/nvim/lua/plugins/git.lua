return {
    {
        "tpope/vim-fugitive",
        enabled = not USE_LAZYGIT,
        event = "VeryLazy",
        config = function()
            -- Register once globally; Git commands handle non-repo errors themselves
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "fugitive: git status" })
            vim.keymap.set("n", "<leader>gp", function() vim.cmd.Git("push") end, { desc = "fugitive: git push" })
            vim.keymap.set("n", "<leader>gP", ":Git push -u origin", { desc = "fugitive: git push[-u origin]" })
            vim.keymap.set("n", "<leader>gr", ":Git pull --rebase<CR>", { desc = "fugitive: git pull[rebase]" })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPost",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "" },
                    topdelete = { text = "" },
                    changedelete = { text = "▎" },
                    untracked = { text = "▎" },
                },
                current_line_blame = true,
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

                    map("n", "]h", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "gitsigns: next hunk" })
                    map("n", "[h", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "gitsigns: prev hunk" })

                    -- stylua: ignore start
                    map("n", "<leader>ghs", gs.stage_hunk, { desc = "gitsigns: stage hunk" })
                    map("v", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "gitsigns: stage hunk" })
                    map("n", "<leader>ghr", gs.reset_hunk, { desc = "gitsigns: reset hunk" })
                    map("v", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "gitsigns: reset hunk" })
                    map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "gitsigns: undo stage" })
                    map("n", "<leader>ghS", gs.stage_buffer, { desc = "gitsigns: stage buffer" })
                    map("n", "<leader>ghR", gs.reset_buffer, { desc = "gitsigns: reset buffer" })
                    map("n", "<leader>ghh", gs.preview_hunk, { desc = "gitsigns: preview hunk" })
                    -- stylua: ignore end

                    map("n", "<leader>ghd", function()
                        if vim.wo.diff then
                            for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                                local buf = vim.api.nvim_win_get_buf(w)
                                if vim.api.nvim_buf_get_name(buf):match("^gitsigns://") then
                                    vim.api.nvim_win_close(w, false)
                                    break
                                end
                            end
                            vim.cmd("diffoff!")
                        else
                            gs.diffthis()
                        end
                    end, { desc = "gitsigns: toggle diff" })
                    -- <leader>gb is taken by snacks (blame line popup)
                    map("n", "<leader>ghb", gs.toggle_current_line_blame, { desc = "gitsigns: toggle blame" })
                end,
            })
        end,
    },
}
