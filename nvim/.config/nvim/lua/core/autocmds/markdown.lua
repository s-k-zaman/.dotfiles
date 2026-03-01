-- Set conceallevel for Markdown files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        --  needed for obsidian-nvim
        vim.wo.conceallevel = 1 -- Adjust conceallevel (0, 1, 2, or 3)
    end,
})

-- for obsidian-nvim smart action keymap
vim.api.nvim_create_autocmd("User", {
    pattern = "ObsidianNoteEnter",
    callback = function(ev)
        vim.b[ev.buf].obsidian_note = true
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(ev)
        vim.defer_fn(function()
            if vim.b[ev.buf].obsidian_note then
                return
            end

            -- Add all actions that needed from obsidian-nvim
            -- Check this: https://github.com/obsidian-nvim/obsidian.nvim/blob/main/lua/obsidian/autocmds.lua
            local api = require("obsidian.api")
            vim.keymap.set(
                "n",
                "<CR>",
                api.smart_action,
                { expr = true, buffer = true, desc = "Smart Action [from Obsidian plugin]" }
            )
        end, 50) -- wait 50ms to let Obsidian event fire
    end,
})
