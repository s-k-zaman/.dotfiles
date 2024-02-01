return {
    defaults = {
        lazy = true,
    },
    install = {
        colorscheme = { COLORSCHEME, "onedark", "habamax" },
    },
    rtp = {
        disabled_plugins = {
            "gzip",
            "matchit",
            "matchparen",
            "netrwPlugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
        },
    },
    change_detection = {
        notify = false, -- notify on change_detection.
    },
}
