local function config()
    require("obsidian").setup({
        workspaces = {
            {
                name = "Notes",
                path = "~/Drive/Notes",
            },
        },

        notes_subdir = "inbox",
        new_notes_location = "notes_subdir",

        disable_frontmatter = true,
        templates = {
            subdir = "templates",
            time_format = "%H:%M:%S",
        },
        ui = {
            enabled = false,
            checkboxes = {
                [" "] = { char = "☐", hl_group = "ObsidianTodo" },
                ["x"] = { char = "✔", hl_group = "ObsidianDone" },
            },
        },
    })

    -- convert note to template and remove leading white-space
    vim.keymap.set(
        "n",
        "<leader>on",
        ":ObsidianTemplate note-template<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>",
        { desc = "Insert `note-template`" }
    )

    -- strip date from note title and replace dashes with spaces
    -- must have cursor on title
    vim.keymap.set("n", "<leader>of", [[:s/\v_20\d{2}-\d{2}-\d{2}//g | s/-/ /g<CR>]], { desc = "Format title" })

    --TODO: -- for review workflow
    -- -- move file in current buffer to zettelkasten folder
    -- vim.keymap.set(
    --     "n",
    --     "<leader>ok",
    --     ":!mv '%:p' /Users/alex/library/Mobile\\ Documents/iCloud~md~obsidian/Documents/ZazenCodes/zettelkasten<cr>:bd<cr>",
    --     { desc = "" }
    -- )
    -- delete file in current buffer
    vim.keymap.set("n", "<leader>odd", ":!trash -v '%:p'<cr>:bd<cr>", { desc = "delete this file/Note" })
end

return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = config,
}
