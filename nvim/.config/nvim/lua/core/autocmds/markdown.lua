local augroup = require("utils").augroup

-- conceallevel needed for obsidian-nvim rendering
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("markdown_conceal"),
    pattern = "markdown",
    callback = function()
        vim.wo.conceallevel = 1
    end,
})

-- smart action keymap for non-obsidian markdown buffers
vim.api.nvim_create_autocmd("User", {
    group = augroup("obsidian_note_enter"),
    pattern = "ObsidianNoteEnter",
    callback = function(ev)
        vim.b[ev.buf].obsidian_note = true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("markdown_smart_action"),
    pattern = "markdown",
    callback = function(ev)
        vim.defer_fn(function()
            if vim.b[ev.buf].obsidian_note then
                return
            end
            -- https://github.com/obsidian-nvim/obsidian.nvim/blob/main/lua/obsidian/autocmds.lua
            local api = require("obsidian.api")
            vim.keymap.set(
                "n",
                "<CR>",
                api.smart_action,
                { expr = true, buffer = true, desc = "Obsidian smart action" }
            )
        end, 50) -- wait for ObsidianNoteEnter to fire first
    end,
})
