local PluginUtils = require("utils.plugins")

------ :Format command --------
local function format(bufnr)
    local msg = "❌[Formatter]: enable lsp.capabilities.(formattings) OR setup formatter for this filetype..."
    if PluginUtils.has("conform.nvim") then
        local ok = require("conform").format({ bufnr = bufnr, lsp_format = "fallback" })
        if not ok then
            vim.notify(msg, vim.log.levels.WARN)
        end
        return
    end
    -- NOTE: vim.lsp.buf.format() always returns nil — cannot check success
    vim.lsp.buf.format({ bufnr = bufnr })
end
vim.api.nvim_create_user_command("Format", function()
    format(vim.api.nvim_get_current_buf())
end, {
    desc = "Format command (conform|lsp)",
})
-- Auto Formatting
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat or not vim.g.autoformat then
            return
        end
        format(args.buf)
    end,
})

return {
    -- IMPORTANT: either use conform or null_ls for a specific filetype formatting
    {
        "stevearc/conform.nvim",
        -- enabled = false,
        event = { "BufReadPre", "BufNewFile" },
        cmd = "ConformInfo",
        opts = function()
            ---@class ConformOpts
            local opts = {
                default_format_opts = {
                    timeout_ms = 8000,
                    async = false, -- not recommended to change
                    quiet = false, -- not recommended to change
                },
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "isort", "black" },
                    -- fish = { "fish_indent" },
                    sh = { "shfmt" },
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                    typescript = { "prettierd", "prettier", stop_after_first = true },
                    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                    vue = { "prettierd", "prettier", stop_after_first = true },
                    css = { "prettierd", "prettier", stop_after_first = true },
                    scss = { "prettierd", "prettier", stop_after_first = true },
                    less = { "prettierd", "prettier", stop_after_first = true },
                    html = { "prettierd", "prettier", stop_after_first = true },
                    -- xhtml = { "prettierd", "prettier", stop_after_first = true },
                    xml = { "prettierd", "prettier", stop_after_first = true },
                    json = { "prettierd", "prettier", stop_after_first = true },
                    jsonc = { "prettierd", "prettier", stop_after_first = true },
                    yaml = { "prettierd", "prettier", stop_after_first = true },
                    -- markdown = { "prettierd", "prettier", stop_after_first = true },
                    -- ["markdown.mdx"] = { "prettierd", "prettier", stop_after_first = true },
                    graphql = { "prettierd", "prettier", stop_after_first = true },
                    handlebars = { "prettierd", "prettier", stop_after_first = true },
                    go = { "gofmt", stop_after_first = true },
                    rust = { "rustfmt", stop_after_first = true },
                },
                -- The options you set here will be merged with the builtin formatters.
                -- You can also define any custom formatters here.
                formatters = {
                    -- injected = { options = { ignore_errors = true } },
                    -- shfmt = { prepend_args = { "-i", "2", "-ci" } },
                    prettier = {
                        cwd = require("conform.util").root_file({
                            ".prettierrc",
                            ".prettierrc.json",
                            ".prettierrc.js",
                            ".prettierrc.cjs",
                            ".prettierrc.mjs",
                            ".prettierrc.yml",
                            ".prettierrc.yaml",
                            ".prettierrc.toml",
                            "prettier.config.js",
                            "prettier.config.cjs",
                            "prettier.config.mjs",
                            "package.json",
                        }),
                    },
                },
            }
            return opts
        end,
        config = function(_, opts)
            require("conform").setup(opts)
        end,
    },
}
