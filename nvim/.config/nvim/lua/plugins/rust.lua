return {

    {
        "saecki/crates.nvim",
        tag = "stable",
        event = { "BufRead Cargo.toml" },
        config = function()
            require("crates").setup({})
        end,
    },
    {
        "simrat39/rust-tools.nvim",
        ft = "rust",
        lazy = false,
        -- enabled = false,
        -- NOTE: on_attach keymaps handled by LspAttach autocmd in lsp/init.lua
        config = function()
            require("rust-tools").setup({
                server = {
                    standalone = true,
                },
                tools = {
                    hover_actions = {
                        auto_focus = false,
                    },
                },
            })
        end,
    },
}
