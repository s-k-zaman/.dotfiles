return {
    {
        "williamboman/mason-lspconfig.nvim",
        event = "BufReadPre",
        dependencies = {
            {
                "williamboman/mason.nvim",
                cmd = "Mason",
                event = "BufReadPre",
                build = ":MasonUpdate",
                opts = {
                    ui = {
                        icons = {
                            package_installed = "✓",
                            package_pending = "➜",
                            package_uninstalled = "✗",
                        },
                    },
                    max_concurrent_installers = 10,
                },
            },
        },
        opts = {
            automatic_installation = true,
            ensure_installed = {
                -- ONLY LSP HERE
                "lua_ls",
                "cssls",
                "marksman",
                "pyright",
                "ruff_lsp",
                "eslint",
                "ts_ls",
                "jsonls",
                "tailwindcss",
                "emmet_ls",
                "rust_analyzer",
                "taplo",
            },
        },
        config = function(_, opts)
            -- OTHER FORMATTERS TO INSTALL FOR none-ls[null-ls FORK], conform etc.
            -- USING :MasonInstallAll COMMAND
            local formatters_linters_servers = {
                "stylua",
                "shfmt",
                "prettier",
                "isort",
                "black",
            }
            vim.api.nvim_create_user_command("MasonInstallAll", function()
                vim.cmd("MasonInstall " .. table.concat(formatters_linters_servers, " "))
            end, {})
            vim.g.mason_binaries_list = formatters_linters_servers
            require("mason-lspconfig").setup(opts)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
            "hrsh7th/nvim-cmp",
            "williamboman/mason-lspconfig.nvim",
            "nvimtools/none-ls.nvim",
            "nvimdev/lspsaga.nvim",
        },
        config = function()
            require("plugins.lsp.lspconfig")
        end,
    },
    {
        "nvimdev/lspsaga.nvim",
        -- enabled = false,
        config = function()
            require("lspsaga").setup({
                ui = {
                    code_action = "",
                },
                symbol_in_winbar = {
                    enable = true,
                    separator = "  ",
                    hide_keyword = true,
                    show_file = false,
                    folder_level = 0,
                },
            })
        end,
    },
    {
        "smjonas/inc-rename.nvim",
        event = "BufReadPre",
        cmd = "IncRename",
        config = function()
            require("inc_rename").setup()
        end,
    },
}
