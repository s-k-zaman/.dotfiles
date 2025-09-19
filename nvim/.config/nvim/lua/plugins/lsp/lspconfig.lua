local PluginUtil = require("utils.plugins")
local utils = require("utils")

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = require("plugins.lsp.lsp_mappings").on_attach

if PluginUtil.has("neoconf.nvim") then
    local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
    require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
end

-- add any global capabilities here
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    {
        -- any additional capabilities
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
    }
)

-- INFO: add LSP autocompletion capability for blink.cmp
if vim.fn.has("nvim-0.11") == 0 and PluginUtil.has("blink.cmp") then
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
end

------ Manage LSP server -----
local mason_lspconfig = require("mason-lspconfig")
local mason_registry = require("mason-registry")

-- defaults for all servers
local defaults = {
    on_attach = on_attach,
    capabilities = capabilities,
}

-- configs and settings
-- INFO:  single_file_support: is assumed by default
-- single_file_support = true, -- ❌ not needed
-- INFO:  single_file_support: set workspace_required=true[->no single file support]/false[-> yes single file support],
local lsp_server_configs = {
    -- lua
    lua_ls = {
        settings = require("plugins.lsp.LspServerSettings.lua_ls"),
    },
    -- html, css
    emmet_ls = {
        filetypes = {
            -- "css",
            "eruby",
            "html",
            "xhtml",
            "javascript",
            "javascriptreact",
            "less",
            -- "sass",
            -- "scss",
            "svelte",
            "pug",
            "typescriptreact",
            "vue",
        },
    },
    cssls = { settings = require("plugins.lsp.LspServerSettings.cssls") },
    tailwindcss = {
        enable = not (PluginUtil.has("tailwind-tools") and not CONFIG_TAILWIND_IN_LSPCONFIG),
        settings = require("plugins.lsp.LspServerSettings.tailwindcss"),
        filetypes = (function()
            local _filetypes = {
                -- got this from
                -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#tailwindcss
                "aspnetcorerazor",
                "astro",
                "astro-markdown",
                "blade",
                "clojure",
                "css",
                "django-html",
                "edge",
                "eelixir",
                "ejs",
                "elixir",
                "erb",
                "eruby",
                "gohtml",
                "gohtmltmpl",
                "haml",
                "handlebars",
                "hbs",
                "heex",
                "html",
                "html-eex",
                "htmlangular",
                "htmldjango",
                "jade",
                "javascript",
                "javascriptreact",
                "javascriptreact",
                "leaf",
                "less",
                "liquid",
                "markdown",
                "mdx",
                "mustache",
                "njk",
                "nunjucks",
                "php",
                "postcss",
                "razor",
                "reason",
                "rescript",
                "sass",
                "scss",
                "slim",
                "stylus",
                "sugarss",
                "svelte",
                "svelte",
                "templ",
                "twig",
                "typescript",
                "typescriptreact",
                "typescriptreact",
                "vue",
                "vue",
                -- default ends
                -- "xhtml",
                "xml",
            }
            local exclude = { "markdown" }
            return vim.tbl_filter(function(ft)
                return not vim.tbl_contains(exclude, ft)
            end, _filetypes)
        end)(),
        -- root_dir = function(...) -- only enabled when it is a git repository
        --     return require("lspconfig.util").root_pattern(".git")(...)
        -- end,
    },
    -- rust
    rust_analyzer = {
        filetypes = { "rust" },
        root_dir = require("lspconfig.util").root_pattern("Cargo.toml"),
        settings = require("plugins.lsp.LspServerSettings.rust_analyzer"),
    },
    -- js/ts
    eslint = { settings = require("plugins.lsp.LspServerSettings.eslint") },
    ts_ls = { settings = require("plugins.lsp.LspServerSettings.tsserver") },
    -- python
    ruff = {
        enable = false,
    },
    pyright = {
        settings = require("plugins.lsp.LspServerSettings.pyright"),
        -- root_dir = function(...) -- INFO: this was for lsp config, check vim.lsp.config api
        --     local root_patterns = {
        --         ".git",
        --         "main.py",
        --     }
        --     -- return require("lspconfig.util").root_pattern(table.unpack(root_patterns))(...) -- INFO: not working
        --     return vim.loop.cwd()
        -- end,
    },
    -- others
    yamlls = { settings = require("plugins.lsp.LspServerSettings.yamlls") },
}

-- 1. Run default for all
vim.lsp.config("*", defaults)

-- 2. Apply specific configs settings
for server_name, config in pairs(lsp_server_configs) do
    if mason_registry.is_installed(server_name) then
        -- disable marked LSPs
        if config.enable == false then
            vim.lsp.enable(server_name, false)
        else
            vim.lsp.config(server_name, vim.tbl_deep_extend("force", {}, defaults, config))
        end
    end
end
-- 3. Remaining configs
-- INFO: there is a way to proiratize servers while conflicting
-- refer to lazy-vnim: https://github.com/LazyVim/LazyVim/ (in lua/lsp/init.lua file)
-- in config of nvim-lspconfig table

-- HACK: As a hack, overriding apply_text_edits works for lsp.rename
-- https://github.com/neovim/neovim/issues/34731
local buggy_servers = {
    -- add more as needed
    "pyright",
    "ruff",
}
local util = require("vim.lsp.util")
local original_apply_text_edits = util.apply_text_edits
-- list of LSP servers that need the hack
util.apply_text_edits = function(text_edits, bufnr, position_encoding, change_annotations)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    -- see if this buffer has any buggy server
    local has_buggy_client = false
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if vim.tbl_contains(buggy_servers, client.name) then
            has_buggy_client = true
            break
        end
    end

    if has_buggy_client then
        for _, edit in ipairs(text_edits or {}) do
            if edit.annotationId then
                edit.annotationId = nil
            end
        end
    end

    return original_apply_text_edits(text_edits, bufnr, position_encoding, change_annotations)
end
