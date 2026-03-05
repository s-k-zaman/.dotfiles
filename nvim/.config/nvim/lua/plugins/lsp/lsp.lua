local PluginUtil = require("utils.plugins")

return {
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
        },
        config = function()
            -- neoconf must run before any LSP server starts
            if PluginUtil.has("neoconf.nvim") then
                local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
                require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
            end

            local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), {
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    },
                },
            })

            vim.lsp.config("*", { capabilities = capabilities })

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
            vim.lsp.handlers["textDocument/signatureHelp"] =
                vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

            local diag_icons = require("utils.glyphs").icons.diagnostics
            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = vim.fn.has("nvim-0.10.0") == 0 and "●" or function(diagnostic)
                        for d, icon in pairs(diag_icons) do
                            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                                return icon
                            end
                        end
                    end,
                },
                severity_sort = true,
                float = { border = "rounded" },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = diag_icons.Error,
                        [vim.diagnostic.severity.WARN] = diag_icons.Warn,
                        [vim.diagnostic.severity.HINT] = diag_icons.Hint,
                        [vim.diagnostic.severity.INFO] = diag_icons.Info,
                    },
                },
            })

            vim.lsp.enable("ruff", false)

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("zaman_nvim_lsp_attach", { clear = true }),
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if not client then
                        return
                    end
                    local bufnr = ev.buf

                    if Disable_Lsp_Server_Formatting then
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                    end

                    local nmap = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc and (desc .. " (lsp)") })
                    end

                    nmap("<leader>ll", function()
                        local clients = vim.lsp.get_clients({ bufnr = bufnr })
                        local names = vim.tbl_map(function(c) return c.name end, clients)
                        vim.cmd("LspRestart")
                        vim.notify(
                            "Restarted: " .. (#names > 0 and table.concat(names, ", ") or "none"),
                            vim.log.levels.INFO
                        )
                    end, "Restart")
                    nmap("<leader>d", vim.lsp.buf.code_action, "Code Action")
                    nmap("K", vim.lsp.buf.hover, "Hover Doc")
                    nmap("<leader>p", vim.diagnostic.open_float, "Show Diagnostics")
                    nmap("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
                    nmap("]d", vim.diagnostic.goto_next, "Next Diagnostic")
                    nmap("<leader>K", vim.lsp.buf.signature_help, "Signature Help")
                    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace: Add")
                    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace: Remove")
                    nmap("<leader>wl", function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, "Workspace: List")

                    if PluginUtil.has("live-rename.nvim") then
                        local live_rename = require("live-rename")
                        vim.keymap.set("n", "<leader>rn", function()
                            live_rename.rename({ cursorpos = -1 })
                            vim.schedule(function()
                                vim.api.nvim_feedkeys("A", "n", false)
                            end)
                        end, { buffer = bufnr, desc = "LSP rename (live)" })
                    else
                        nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
                    end

                    if client.name == "ruff" or client.name == "ruff_lsp" then
                        client.server_capabilities.hoverProvider = false
                    end

                    if client.name == "taplo" then
                        if PluginUtil.has("crates.nvim") then
                            vim.keymap.set("n", "K", function()
                                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                                    require("crates").show_popup()
                                else
                                    vim.lsp.buf.hover()
                                end
                            end, { buffer = bufnr, desc = "Hover Doc (Crate)" })
                        end
                    end

                    if client.name == "rust_analyzer" then
                        vim.keymap.set("n", "<F5>", "<cmd>RustRun<cr>", {
                            buffer = bufnr,
                            desc = "Run program (rust)",
                        })
                    end
                end,
            })

        end,
    },
    {
        "saecki/live-rename.nvim",
        event = "LspAttach",
        config = function()
            require("live-rename").setup({})
        end,
    },
}
