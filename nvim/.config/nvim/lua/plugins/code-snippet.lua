local path = "~/Pictures/code-sanpshots"
return {
    "mistricky/codesnap.nvim",
    build = "make",
    keys = {
        { "<leader>cc", ":'<,'>CodeSnap<cr>", mode = "x", desc = "Copy code snapshot[clipboard]" },
        { "<leader>cs", ":'<,'>CodeSnapSave<cr>", mode = "x", desc = "Save code snapshot[" .. path .. "]" },
        { "<leader>ch", ":'<,'>CodeSnapHighlight<cr>", mode = "x", desc = "Copy code snapshot Highlight" },
        {
            "<leader>cH",
            ":'<,'>CodeSnapSaveHighlight<cr>",
            mode = "x",
            desc = "Save code snapshot with Highlight[" .. path .. "]",
        },
        { "<leader>ca", ":'<,'>CodeSnapASCII<cr>", mode = "x", desc = "Copy code snapshot[ASCII]" },
    },
    opts = {
        save_path = path,
        has_breadcrumbs = true,
        watermark = "",
        bg_theme = "grape",
        bg_color = "#535c68", --INFO: if bg_color is set bg_theme will not work
        -- padding
        bg_padding = 40, -- nil for default, 0 for no padding
    },
}
