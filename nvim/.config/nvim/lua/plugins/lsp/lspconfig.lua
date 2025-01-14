local PluginUtil = require("utils.plugins")
local utils = require("utils")

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = require("plugins.lsp.lsp_mappings").on_attach

if PluginUtil.has("neoconf.nvim") then
    local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
    require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
end

-- add any global capabilities here
local additionl_capabilities = {
    textDocument = {
        foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        },
    },
}

local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    additionl_capabilities or {}
)

-- Ensure the servers below are installed
local server_settings = {
    -- clangd = {},
    -- html = {},
    -- gopls = {},
    -- denols = {},
    cssls = require("plugins.lsp.LspServerSettings.cssls"),
    rust_analyzer = require("plugins.lsp.LspServerSettings.rust_analyzer"),
    eslint = require("plugins.lsp.LspServerSettings.eslint"),
    tsserver = require("plugins.lsp.LspServerSettings.tsserver"),
    yamlls = require("plugins.lsp.LspServerSettings.yamlls"),
    pyright = require("plugins.lsp.LspServerSettings.pyright"),
    lua_ls = require("plugins.lsp.LspServerSettings.lua_ls"),
    tailwindcss = require("plugins.lsp.LspServerSettings.tailwindcss"),
}

------ Manage LSP server using mason_lspconfig -----
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

-- looping through all the servers by setup_handlers and setting the lsp.
mason_lspconfig.setup_handlers({
    -- TODO: make better server handling
    function(server_name)
        if PluginUtil.has("tailwind-tools") and server_name == "tailwindcss" then
            return
        end
        -- local util = require("lspconfig/util")
        lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = server_settings[server_name] or {},
        })
    end,

    -- conditional settings can be done using server_name(eg: pyright, tsserver etc.)
    ["ruff"] = function()
        lspconfig["ruff"].setup({
            enabled = false,
            capabilities = capabilities,
            on_attach = on_attach,
            settings = server_settings["ruff"] or {},
        })
    end,
    ["lua_ls"] = function()
        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = server_settings["lua_ls"] or {},
            single_file_support = true,
        })
    end,
    ["emmet_ls"] = function()
        lspconfig["emmet_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
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
        })
    end,
    ["rust_analyzer"] = function()
        lspconfig["rust_analyzer"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = server_settings["rust_analyzer"] or {},
            filetypes = { "rust" },
            root_dir = require("lspconfig.util").root_pattern("Cargo.toml"),
        })
    end,
    ["pyright"] = function()
        lspconfig["pyright"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = server_settings["pyright"] or {},
            root_dir = function(...)
                local root_patterns = {
                    ".git",
                    "main.py",
                }
                -- return require("lspconfig.util").root_pattern(table.unpack(root_patterns))(...) -- INFO: not working
                return vim.loop.cwd()
            end,
            single_file_support = true,
        })
    end,
    ["tailwindcss"] = function()
        if PluginUtil.has("tailwind-tools") and not CONFIG_TAILWIND_IN_LSPCONFIG then
            return
        end
        -- define filetypes to exclude
        local filetypes_exclude = { "markdown" }
        local filetypes = {}
        local default_ft = {
            -- got this from
            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#tailwindcss
            "aspnetcorerazor",
            "astro",
            "astro-markdown",
            "blade",
            "clojure",
            "django-html",
            "htmldjango",
            "edge",
            "eelixir",
            "elixir",
            "ejs",
            "erb",
            "eruby",
            "gohtml",
            "gohtmltmpl",
            "haml",
            "handlebars",
            "hbs",
            "html",
            -- "xhtml",
            "xml",
            "htmlangular",
            "html-eex",
            "heex",
            "jade",
            "leaf",
            "liquid",
            "markdown",
            "mdx",
            "mustache",
            "njk",
            "nunjucks",
            "php",
            "razor",
            "slim",
            "twig",
            "css",
            "less",
            "postcss",
            "sass",
            "scss",
            "stylus",
            "sugarss",
            "javascript",
            "javascriptreact",
            "reason",
            "rescript",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
            "templ",
        }
        vim.list_extend(filetypes, default_ft)
        filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(filetypes_exclude or {}, ft)
        end, filetypes)

        lspconfig["tailwindcss"].setup({
            -- enabled = false,
            capabilities = capabilities,
            on_attach = on_attach,
            settings = server_settings["tailwindcss"] or {},
            filetypes = filetypes,
            -- root_dir = function(...) -- only enabled when it is a git repository
            --     return require("lspconfig.util").root_pattern(".git")(...)
            -- end,
        })
    end,
})

-- INFO: there is a way to proiratize servers while conflicting
-- refer to lazy-vnim: https://github.com/LazyVim/LazyVim/ (in lua/lsp/init.lua file)
-- in config of nvim-lspconfig table
