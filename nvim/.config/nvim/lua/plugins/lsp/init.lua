return {
    {
        "mason-org/mason-lspconfig.nvim",
        event = "BufReadPre",
        dependencies = {
            {
                "mason-org/mason.nvim",
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
            "neovim/nvim-lspconfig",
        },
        opts = {
            automatic_installation = true,
            -- automatic_enable = false,
            automatic_enable = {
                exclude = {
                    -- excluded in lspconfig.lus file [disabled by vim.lsp.enable]
                    -- "tailwindcss",
                    -- "ruff",
                },
            },
            ensure_installed = {
                -- ONLY LSP HERE
                "lua_ls",
                "cssls",
                "marksman",
                "pyright",
                "ruff",
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
                "prettierd",
                "prettier",
                "isort",
                "black",
                "tree-sitter-cli",
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
            "nvimtools/none-ls.nvim",
        },
        config = function()
            require("plugins.lsp.lspconfig")
        end,
    },
    {
        "nvimdev/lspsaga.nvim",
        enabled = USE_LSP_SAGA,
        event = "LspAttach",
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
        "saecki/live-rename.nvim",
        event = "BufReadPre",
        config = function()
            require("live-rename").setup({})
        end,
    },
    -- TODO: trying live-rename instead inc-rename
    -- {
    --     "smjonas/inc-rename.nvim",
    --     event = "BufReadPre",
    --     cmd = "IncRename",
    --     opts = {
    --         input_buffer_type = "dressing",
    --         save_in_cmdline_history = false,
    --     },
    -- },
}
