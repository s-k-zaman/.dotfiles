-- IMPORTANT: dependencies order is important in this file
return {
    "mason-org/mason-lspconfig.nvim",
    -- automatically enable LSP servers and make Commands available :LspInstall
    -- event = "BufReadPre",
    dependencies = {
        {
            "mason-org/mason.nvim",
            opts = {
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
                -- max_concurrent_installers = 10,
            },
        },
        -- Brings default configs for bunch of LSPs and sets that config automatically.
        -- (Override it by after/lsp/lspname.lua <- placing custom config here)
        "neovim/nvim-lspconfig",
    },
    opts = {
        -- for config refer: https://github.com/mason-org/mason-lspconfig.nvim
        -- better manage LSP in one place: `./lsp.lua`
        ensure_installed = {
            -- INFO: Do not add servers here manually.
            -- HACK: ensure_installed is overwritten in config below for better control.
            -- instead use `:MasonInstallAll` command
        },
    },
    config = function(_, opts)
        require("mason-lspconfig").setup(opts)
        local lsp_linter_formatter_daps = {
            -- LSP Servers
            "lua_ls",
            "stylua",

            "shfmt",
            "shellcheck",

            "pyright",
            "ruff",
            "isort",
            "black",

            "prettierd",
            "cssls",
            "tailwindcss",
            "emmet_ls",

            "ts_ls",
            "eslint_d",
            -- "eslint", -- eslint_d is faster

            "rust_analyzer",

            "gopls",

            "jsonls",
            "marksman",
            "taplo",

            "harper_ls", --grammar
            "tree-sitter-cli",

            -- Linters (driven by nvim-lint in plugins/linting.lua)
            "markdownlint-cli2",
            -- "stylelint", -- uncomment for CSS/SCSS linting
        }

        vim.api.nvim_create_user_command("MasonInstallAll", function()
            local registry = require("mason-registry")
            vim.notify("[Mason] Refreshing registry…", vim.log.levels.INFO)
            registry.refresh(function()
                -- mason mapping (always fresh after refresh)
                local lsp_to_mason = {}
                local map_ok, mappings = pcall(require, "mason-lspconfig.mappings")
                if map_ok and mappings.get_mason_map then
                    local data = mappings.get_mason_map()
                    if data and data.lspconfig_to_package then
                        lsp_to_mason = data.lspconfig_to_package
                    end
                end

                local function resolve(name)
                    return lsp_to_mason[name] or name
                end

                local resolved = {}
                for _, name in ipairs(lsp_linter_formatter_daps) do
                    table.insert(resolved, resolve(name))
                end
                vim.g.mason_binaries_list = resolved

                -- Classify packages
                local to_install = {}
                local already_installed = {}
                local unknown = {}

                for _, name in ipairs(lsp_linter_formatter_daps) do
                    local pkg_name = resolve(name)
                    if registry.has_package(pkg_name) then
                        local pkg = registry.get_package(pkg_name)
                        if pkg:is_installed() then
                            table.insert(already_installed, pkg_name)
                        else
                            table.insert(to_install, pkg_name)
                        end
                    else
                        table.insert(unknown, name .. " → " .. pkg_name)
                    end
                end

                vim.schedule(function()
                    if #unknown > 0 then
                        vim.notify(
                            "[Mason] ⚠ Unknown packages — check names:\n  " .. table.concat(unknown, "\n  "),
                            vim.log.levels.WARN
                        )
                    end
                    if #to_install > 0 then
                        vim.notify(
                            string.format(
                                "[Mason] ⏳ Installing %d / %d packages:\n  %s",
                                #to_install,
                                #to_install + #already_installed,
                                table.concat(to_install, ", ")
                            ),
                            vim.log.levels.INFO
                        )
                        vim.cmd("MasonInstall " .. table.concat(to_install, " "))
                    else
                        vim.notify(
                            string.format("[Mason] ✓ All %d packages already installed!", #already_installed),
                            vim.log.levels.INFO
                        )
                    end
                end)
            end)
        end, { desc = "Install all your LSPs and tools from config." })
    end,
}
