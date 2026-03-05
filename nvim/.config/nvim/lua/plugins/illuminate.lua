return {
    "RRethy/vim-illuminate",
    event = "LspAttach",
    opts = {
        delay = 200,
        providers = { "lsp", "treesitter", "regex" },
        filetypes_denylist = {
            "dirbuf",
            "dirvish",
            "fugitive",
            "snacks_dashboard",
            "NvimTree",
            "neo-tree",
            "lazy",
            "mason",
            "help",
            "toggleterm",
            "qf",
        },
        min_count_to_highlight = 2,
        large_file_cutoff = 10000,
    },
    config = function(_, opts)
        require("illuminate").configure(opts)
    end,
}
