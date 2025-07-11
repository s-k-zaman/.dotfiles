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
    ts_ls = require("plugins.lsp.LspServerSettings.tsserver"),
    yamlls = require("plugins.lsp.LspServerSettings.yamlls"),
    pyright = require("plugins.lsp.LspServerSettings.pyright"),
    lua_ls = require("plugins.lsp.LspServerSettings.lua_ls"),
    tailwindcss = require("plugins.lsp.LspServerSettings.tailwindcss"),
}

------ Manage LSP server using mason_lspconfig -----
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

vim.lsp.config("*", {
    on_attach = on_attach,
    capabilities = capabilities,
})
for server_name, settings in pairs(server_settings) do
    if vim.lsp.config[server_name] then
        vim.lsp.config(server_name, {
            settings = settings or {},
        })
    end
end
--ruff
vim.lsp.enable("ruff", false)
-- lua_ls
vim.lsp.config("lua_ls", {
    single_file_support = true,
})
-- emmet_ls
vim.lsp.config("emmet_ls", {
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

-- rust_analyzer
vim.lsp.config("rust_analyzer", {
    filetypes = { "rust" },
    root_dir = require("lspconfig.util").root_pattern("Cargo.toml"),
})
------ pyright
vim.lsp.config("pyright", {
    -- root_dir = function(...) -- INFO: this was for lsp config, check vim.lsp.config api
    --     local root_patterns = {
    --         ".git",
    --         "main.py",
    --     }
    --     -- return require("lspconfig.util").root_pattern(table.unpack(root_patterns))(...) -- INFO: not working
    --     return vim.loop.cwd()
    -- end,
    single_file_support = true,
})

------ tailwindcss
local enable_tailwind = not (PluginUtil.has("tailwind-tools") and not CONFIG_TAILWIND_IN_LSPCONFIG)
if enable_tailwind then
    vim.lsp.enable("tailwindcss", enable_tailwind)
    -- setup
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
    vim.lsp.config("tailwindcss", {
        filetypes = filetypes,
        -- root_dir = function(...) -- only enabled when it is a git repository
        --     return require("lspconfig.util").root_pattern(".git")(...)
        -- end,
    })
end

-- INFO: there is a way to proiratize servers while conflicting
-- refer to lazy-vnim: https://github.com/LazyVim/LazyVim/ (in lua/lsp/init.lua file)
-- in config of nvim-lspconfig table
