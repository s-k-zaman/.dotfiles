local M = {}

-- Per-buffer cache: { [bufnr] = rendered_string }
local _cache = {}

-- Setup invalidation autocmds once
local _setup_done = false
local function setup()
    if _setup_done then
        return
    end
    _setup_done = true
    vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("zaman_nvim_lsp_info_cache", { clear = true }),
        callback = function(ev)
            _cache[ev.buf] = nil
        end,
    })
end

-- Highlight groups for each category
local hl = {
    lsp = "%#lualine_c_diagnostics_info_normal#", -- cyan/teal  → LSP servers
    fmt = "%#lualine_c_diagnostics_warn_normal#", -- blue       → formatters
    lint = "%#lualine_c_diagnostics_hint_normal#", -- yellow     → linters
    dap = "%#Special#", -- purple     → DAP adapters
    err = "%#lualine_c_diagnostics_error_normal#", -- red        → nothing attached
}

-- Per-category truncation limits: 0 = show all, N = cap at N names with "…"
local limits = {
    lsp = 0,
    fmt = 0,
    lint = 0,
    dap = 0,
}

local function render_list(items, limit)
    if limit > 0 and #items > limit then
        return table.concat(items, ", ", 1, limit) .. "…"
    end
    return table.concat(items, ", ")
end

M.get_lsps = function()
    local bufnr = vim.api.nvim_get_current_buf()
    -- Skip non-file buffers (dashboard, help, terminals, etc.)
    if vim.bo[bufnr].buftype ~= "" then
        return ""
    end

    setup()

    if _cache[bufnr] then
        return _cache[bufnr]
    end

    local ft = vim.bo[bufnr].filetype
    local seen = {}
    local fmts = {}
    local lints = {}
    local lsps = {}
    local daps = {}

    -- 1. Conform formatters (highest precedence — listed first to populate `seen`)
    local ok_cf, conform = pcall(require, "conform")
    if ok_cf then
        for _, f in ipairs(conform.list_formatters(bufnr)) do
            if f.available and not seen[f.name] then
                seen[f.name] = true
                table.insert(fmts, f.name)
            end
        end
    end

    -- 2. nvim-lint linters (precedence over LSP for diagnostics display)
    local ok_lint, lint = pcall(require, "lint")
    if ok_lint then
        for _, name in ipairs(lint.linters_by_ft[ft] or {}) do
            if not seen[name] then
                seen[name] = true
                table.insert(lints, name)
            end
        end
    end

    -- 3. LSP clients attached to this buffer (skip names already claimed above)
    if rawget(vim, "lsp") then
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            -- none-ls / null-ls is an aggregator; skip the client itself
            if client.name ~= "null-ls" and client.name ~= "none-ls" and not seen[client.name] then
                seen[client.name] = true
                table.insert(lsps, client.name)
            end
        end

        -- none-ls sources (maintained fork of null-ls)
        local ok_nls, nls = pcall(require, "none-ls")
        if ok_nls then
            for _, src in ipairs(nls.get_sources()) do
                if src.filetypes[ft] and not seen[src.name] then
                    seen[src.name] = true
                    table.insert(lsps, src.name)
                end
            end
        end
    end

    -- 4. nvim-dap adapters for this filetype (future-proof; no-ops if dap not installed)
    local ok_dap, dap = pcall(require, "dap")
    if ok_dap then
        for _, cfg in ipairs((dap.configurations or {})[ft] or {}) do
            local adapter = cfg.type
            if adapter and not seen[adapter] then
                seen[adapter] = true
                table.insert(daps, adapter)
            end
        end
    end

    -- Build display string
    local parts = {}

    if #lsps > 0 then
        table.insert(parts, hl.lsp .. " " .. render_list(lsps, limits.lsp))
    end
    if #fmts > 0 then
        table.insert(parts, hl.fmt .. "󰅩 " .. render_list(fmts, limits.fmt))
    end
    if #lints > 0 then
        table.insert(parts, hl.lint .. " " .. render_list(lints, limits.lint))
    end
    if #daps > 0 then
        table.insert(parts, hl.dap .. "  " .. render_list(daps, limits.dap))
    end

    local result = (#parts > 0 and table.concat(parts, " ") or (hl.err .. "󰅚 no lsp")) .. hl.err .. " "
    _cache[bufnr] = result
    return result
end

return M
