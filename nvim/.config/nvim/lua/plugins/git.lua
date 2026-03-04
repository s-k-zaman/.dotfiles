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

                    -- navigation (works in diff mode too)
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
                    -- hunk actions
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
                    -- <leader>gb is taken by snacks (blame line popup); use ghb for toggle
                    map("n", "<leader>ghb", gs.toggle_current_line_blame, { desc = "gitsigns: toggle blame" })
                end,
            })
        end,
    },
}
