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
        config = function()
            local rt = require("rust-tools")

            rt.setup({
                server = {
                    -- rust tools commands are controlled in on_attach of lsp_mappings
                    on_attach = require("plugins.lsp.lsp_mappings").on_attach,
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
