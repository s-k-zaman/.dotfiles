local bullets_vim_fts = { "markdown", "text", "gitcommit", "scratch" }
return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            completions = { lsp = { enabled = true } },
            render_modes = { "n", "c", "t" },
        },
    },
    {
        "bullets-vim/bullets.vim",
        ft = bullets_vim_fts,
        config = function()
            -- Override alt+j/k with auto-renumber for list filetypes
            local function set_move_keymaps(buf)
                local o = { buffer = buf, silent = true }
                -- stylua: ignore start
                vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==<cmd>RenumberList<cr>", vim.tbl_extend("force", o, { desc = "Move line down" }))
                vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==<cmd>RenumberList<cr>", vim.tbl_extend("force", o, { desc = "Move line up" }))
                vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==<cmd>RenumberList<cr>gi", vim.tbl_extend("force", o, { desc = "Move line down" }))
                vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==<cmd>RenumberList<cr>gi", vim.tbl_extend("force", o, { desc = "Move line up" }))
                vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv<cmd>RenumberList<cr>", vim.tbl_extend("force", o, { desc = "Move line down" }))
                vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv<cmd>RenumberList<cr>", vim.tbl_extend("force", o, { desc = "Move line up" }))
                -- stylua: ignore end
            end

            -- Apply to the buffer that triggered the lazy load
            set_move_keymaps(vim.api.nvim_get_current_buf())

            -- Apply to all subsequent matching buffers
            vim.api.nvim_create_autocmd("FileType", {
                pattern = bullets_vim_fts,
                callback = function(ev)
                    set_move_keymaps(ev.buf)
                end,
            })
        end,
        init = function()
            -- Delete empty bullet on enter (2 = promote then delete on repeat)
            vim.g.bullets_delete_last_bullet_if_empty = 2

            -- Auto-indent after a bullet ending with colon (e.g. "Steps:")
            vim.g.bullets_auto_indent_after_colon = 1

            -- Keep numbering in sync when reordering / changing indent
            vim.g.bullets_renumber_on_change = 1

            -- Align text after multi-char bullets (e.g. "10. ")
            vim.g.bullets_pad_right = 1

            -- Hierarchy used when pressing <C-t>/<C-d> to change indent level:
            -- num → abc → std- (dash) → std* (asterisk) → std+ (plus)
            vim.g.bullets_outline_levels = { "num", "abc", "std-", "std*", "std+" }

            -- Nested checkbox tracking (parent reflects children completion)
            vim.g.bullets_nested_checkboxes = 1

            -- Checkbox states: unchecked → partial → checked
            vim.g.bullets_checkbox_markers = " .oOX"
            vim.g.bullets_checkbox_partials_toggle = 1
        end,
    },
    {
        "ellisonleao/glow.nvim",
        cmd = "Glow",
        ft = { "markdown" },
        config = function()
            require("glow").setup()
            vim.keymap.set("n", "<leader>mp", "<cmd>Glow<cr>", { desc = "markdown preview[glow]" })
        end,
    },
}
