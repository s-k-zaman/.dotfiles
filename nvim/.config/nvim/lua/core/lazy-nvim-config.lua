return {
    defaults = {
        -- lazy = false,
    },
    spec = {
        { import = "plugins" },
        { import = "plugins.lsp" },
    },
    install = {
        colorscheme = { COLORSCHEME, "onedark", "habamax" },
    },
    rtp = {
        disabled_plugins = {
            "netrwPlugin", -- default file manager
            "gzip",
            -- "matchit",
            "matchparen",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
            "vimball",
            "vimballPlugin",
            "getscript",
            "getscriptPlugin",
        },
    },
    checker = {
        enable = true,
        notify = false,
    },
    change_detection = {
        notify = false, -- notify on change_detection.
    },
}
