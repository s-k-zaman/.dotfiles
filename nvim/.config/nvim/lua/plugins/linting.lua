return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            -- Shell
            sh = { "shellcheck" },
            bash = { "shellcheck" },

            -- Python — ruff as linter; pyright handles type-checking via LSP
            python = { "ruff" },

            -- JavaScript / TypeScript
            -- NOTE: eslint_d is faster than the eslint LSP linter.
            -- If you see duplicate diagnostics, disable the eslint LSP in lsp.lua
            -- by adding: vim.lsp.enable("eslint", false)
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            vue = { "eslint_d" },

            -- Markup / Config
            markdown = { "markdownlint-cli2" },

            -- CSS / SCSS — commented out: cssls LSP covers most diagnostics.
            -- Uncomment and install stylelint via :MasonInstallAll if needed.
            -- css  = { "stylelint" },
            -- scss = { "stylelint" },
        }

        -- Add any filetype here to skip auto-linting for it
        -- (linter can still be run manually: :lua require("lint").try_lint())
        local excluded_filetypes = {
            -- UI / plugin windows
            "lazy",
            "mason",
            "snacks_dashboard",
            "snacks_notif",
            "snacks_explorer",
            "neo-tree",
            "Trouble",
            "toggleterm",
            -- Vim built-ins
            "help",
            "man",
            "qf", -- quickfix
            "checkhealth",
            -- Git
            "gitcommit",
            "gitrebase",
        }

        -- vim.g.autolint = true/false  — global on/off (core/options)
        -- vim.b.autolint = false       — per-buffer override
        -- Toggle keymap: <leader>ux    (via Snacks.toggle in snacks/)
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
            group = vim.api.nvim_create_augroup("zaman_nvim_lint", { clear = true }),
            callback = function(args)
                local ft = vim.bo[args.buf].filetype
                if
                    not vim.g.autolint
                    or vim.b[args.buf].autolint == false
                    or vim.tbl_contains(excluded_filetypes, ft)
                then
                    return
                end
                lint.try_lint()
            end,
        })
    end,
}
