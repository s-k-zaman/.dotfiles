local PluginUtil = require("utils.plugins")

local M = {}

M.on_attach = function(client, bufnr)
    if Disable_Lsp_Server_Formatting then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end

    if PluginUtil.has("nvim-naviac") then
        if client.server_capabilities.documentSymbolProvider then
            local naviac = require("nvim-navic")
            naviac.attach(client, bufnr) -- attaching naviac.
        end
    end

    -- MAPPING FUNCTIONS
    local use_saga = USE_LSP_SAGA
    local nmap = function(keys, func, desc)
        if desc then
            desc = desc .. " (lsp)"
        end
        vim.keymap.set("n", keys, func, {
            buffer = bufnr,
            desc = desc,
            -- noremap = true,
        })
    end
    local nmap_saga = function(keys, func, desc)
        if desc then
            desc = desc .. " (lsp saga)"
        end
        vim.keymap.set("n", keys, func, {
            buffer = bufnr,
            desc = desc,
            -- noremap = true,
        })
    end

    vim.keymap.set("n", "<leader>ll", "<cmd>LspRestart<CR>", {
        desc = "Lsp: restart",
    })
    -- KEY MAPPINGS
    -- Renaming
    if PluginUtil.has("live-rename.nvim") then
        local live_rename = require("live-rename")
        vim.keymap.set("n", "<leader>rn", function()
            live_rename.rename({ cursorpos = -1 })

            -- put into append mode immediately, as insert-mode is placing cursor before
            vim.schedule(function()
                vim.api.nvim_feedkeys("A", "n", false)
            end)
        end, { desc = "LSP rename(live)" })
    elseif PluginUtil.has("inc-rename.nvim") then
        vim.keymap.set("n", "<leader>rn", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end, { desc = "[R]e[n]ame (inc_rename)", expr = true })
    else
        if PluginUtil.has("lspsaga.nvim") and use_saga then
            -- FIX: here rename box is not good
            nmap_saga("<leader>rn", "<cmd>Lspsaga rename<cr>", "[R]e[n]ame -> c-k:quit")
        else
            nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame buffer")
        end
    end

    if PluginUtil.has("lspsaga.nvim") and use_saga then
        nmap_saga("<leader>d", "<cmd>Lspsaga code_action<cr>", "Code [A]ctions")

        -- nmap_saga("gd", "<cmd>Lspsaga goto_definition<cr>", "[g]oto [d]efinition") --INFO: using snacks picker for this
        nmap_saga("gh", "<cmd>Lspsaga peek_definition<cr>", "[g]et definition [h]ere")

        nmap_saga("K", "<cmd>Lspsaga hover_doc<cr>", "Hover Doc")

        nmap_saga("<leader>p", "<cmd>Lspsaga show_line_diagnostics<cr>", "Show Diagnostics/[p]roblems")
        nmap_saga("<leader>P", "<cmd>Lspsaga show_cursor_diagnostics<cr>", "Show (curr loc) Diagnostic/[P]roblem")

        nmap_saga("[d", "<cmd>Lspsaga diagnostic_jump_next<cr>", "Goto next [d]iagnostic")
        nmap_saga("]d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Goto prev [d]iagnostic")
    else
        nmap("<leader>d", vim.lsp.buf.code_action, "Code [A]ctions")

        -- nmap("gd", vim.lsp.buf.definition, "[g]oto [d]efinition") --INFO: using snacks picker for this

        nmap("K", vim.lsp.buf.hover, "Hover Doc")

        nmap("<leader>p", function()
            vim.diagnostic.open_float()
        end, "Show Diagnostics/[p]roblems")

        nmap("[d", function()
            vim.diagnostic.goto_next()
        end, "Goto next [d]iagnostic")
        nmap("]d", function()
            vim.diagnostic.goto_prev()
        end, "Goto prev [d]iagnostic")
    end
    nmap("<leader>K", vim.lsp.buf.signature_help, "Hover Signature Help")

    -- nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation") -- TODO: not working/know more
    -- nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition") -- TODO: not working/know more
    --nmap("gs", vim.lsp.buf.declaration, "[G]oto [D]eclaration")-- TODO: not working/know more
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace: [A]dd this root")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace: [R]emove this root")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace: [L]ist Folders")

    -- condition capabilities
    if client.name == "ruff_lsp" then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
    end

    -- TOML file specific keymaps or modifications
    if client.name == "taplo" then
        if PluginUtil.has("crates.nvim") then
            vim.keymap.set("n", "K", function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                    -- FIX: not using this, using lspsaga
                    require("crates").show_popup()
                elseif PluginUtil.has("lspsaga.nvim") then
                    nmap_saga("K", "<cmd>Lspsaga hover_doc<cr>", "Hover Doc")
                else
                    vim.lsp.buf.hover()
                end
            end, { desc = "Hover Doc (Crate)" })
        end
    end

    -- IMPORTANT: rust-tools specific behavior/mappings here...
    -- along with lsp mappings
    if client.name == "rust_analyzer" then
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true

        local nmap_rust = function(keys, func, desc)
            if desc then
                desc = desc .. " (rust)"
            end
            vim.keymap.set("n", keys, func, {
                buffer = bufnr,
                desc = desc,
                -- noremap = true,
            })
        end
        nmap_rust("<F5>", "<cmd>RustRun<cr>", "run program")
        if PluginUtil.has("rust-tools.nvim") then
            local rt = require("rust-tools")

            nmap_rust("K", "<cmd>RustHoverActions<cr>", "Hover Doc")
            nmap_rust("<leader>A", "<cmd>RustCodeAction<cr>", "Code [A]ction")
            nmap_rust("<leader>ag", rt.code_action_group.code_action_group, "Code [A]ction groups")
        end
    end
end

return M
