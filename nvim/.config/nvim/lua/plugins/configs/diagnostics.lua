--------------- diagnostic, viwes -----------------
local opts = {
    diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
            spacing = 4,
            source = "if_many",
            --prefix = "●",
            -- prefix `icons` will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            prefix = "icons",
        },
        severity_sort = true,
        signs = {
            -- show icon on left hint bar?
            is_icon = false,
        },
    },
}

if vim.fn.has("nvim-0.11") == 0 and opts.diagnostics.signs.is_icon then
    -- version is lower than 0.11
    for name, icon in pairs(require("utils.glyphs").icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    end
end

if vim.fn.has("nvim-0.11") == 1 and opts.diagnostics.signs.is_icon then
    -- version is higher than 0.11
    local icons = require("utils.glyphs").icons.diagnostics
    opts.diagnostics.signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN] = icons.Warn,
            [vim.diagnostic.severity.HINT] = icons.Hint,
            [vim.diagnostic.severity.INFO] = icons.Info,
        },
    }
end

if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
    opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
        or function(diagnostic)
            local icons = require("utils.glyphs").icons.diagnostics
            for d, icon in pairs(icons) do
                if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                    return icon
                end
            end
        end
end

vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
