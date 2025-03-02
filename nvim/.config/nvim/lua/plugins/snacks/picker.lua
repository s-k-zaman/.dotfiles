return {
    enabled = true,
    debug = {
        -- scores = true, -- show scores in the list
    },
    matcher = {

        frecency = true, -- frecency bonus
    },
    exclude = { -- INFO: excludes these in all pickers
        -- python venv folders
        "venv/",
        ".venv/",
        "__pycache__/",

        "node_modules",

        ".obsidian",
    },
    formatters = {
        file = {
            filename_first = false,
            filename_only = false,
            icon_width = 2,
        },
    },
    smart = {
        Config = {
            multi = {
                -- "buffers",
                -- "recent",
                "files",
            },
        },
    },
    layout = {
        -- presets options : "default" , "ivy" , "ivy-split" , "telescope" , "vscode", "select" , "sidebar"
        -- override picker layout in keymaps function as a param below
        cycle = false,
    },
    layouts = {
        --INFO: arrange the objects as desired to match layout preference
        select = {
            preview = false,
            layout = {
                backdrop = false,
                width = 0.6,
                min_width = 80,
                height = 0.4,
                min_height = 10,
                box = "vertical",
                border = "rounded",
                title = "{title}",
                title_pos = "center",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", width = 0.6, height = 0.4, border = "top" },
            },
        },
        telescope = {
            --INFO: set reverse to false for search bar to be on top
            reverse = false,
            layout = {
                box = "horizontal",
                backdrop = false,
                width = 0.8,
                height = 0.9,
                border = "none",
                {
                    box = "vertical",
                    {
                        win = "input",
                        height = 1,
                        border = "rounded",
                        title = "{title} {live} {flags}",
                        title_pos = "center",
                    },
                    { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
                },
                {
                    win = "preview",
                    title = "{preview:Preview}",
                    width = 0.55,
                    border = "rounded",
                    title_pos = "center",
                },
            },
        },
        ivy = {
            layout = {
                box = "vertical",
                backdrop = false,
                width = 0,
                height = 0.4,
                position = "bottom",
                border = "top",
                title = " {title} {live} {flags}",
                title_pos = "left",
                { win = "input", height = 1, border = "bottom" },
                {
                    box = "horizontal",
                    { win = "list", border = "none" },
                    { win = "preview", title = "{preview}", width = 0.5, border = "left" },
                },
            },
        },
    },
    on_close = function()
        if vim.env.NVIM_TMUX_KEY then -- If NVIM_TMUX_KEY env is set. i.e. -> coming from tmux
            vim.cmd("qa!") -- Exit Neovim
        end
    end,
}
