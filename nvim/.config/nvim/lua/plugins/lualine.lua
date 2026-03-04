return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local icons = require("utils.glyphs").icons
            require("lualine").setup({
                options = {
                    theme = "auto",
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
                    component_separators = {
                        left = "",
                        right = "",
                    },
                    section_separators = {
                        left = "",
                        right = "",
                    },
                },
                sections = {
                    -- left sections
                    lualine_a = { "mode" },
                    lualine_b = {
                        "branch",
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                        },
                    },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                        {
                            -- Shows linters actively running right now (dynamic feedback).
                            -- Complements lsp-info which shows statically configured tools.
                            function()
                                local ok, lint = pcall(require, "lint")
                                if not ok then
                                    return ""
                                end
                                local running = lint.get_running()
                                if #running == 0 then
                                    return ""
                                end
                                return "󱉶 " .. table.concat(running, ", ")
                            end,
                        },
                        {
                            -- Only visible for unnamed/scratch buffers (incline already shows names).
                            "filename",
                            cond = function()
                                return vim.api.nvim_buf_get_name(0) == ""
                            end,
                            symbols = { modified = "󰛓 ", readonly = " ", unnamed = "[No Name]" },
                        },
                    },
                    -- right sections
                    lualine_x = {
                        {
                            function()
                                return require("modules.ui.lsp-info").get_lsps()
                            end,
                        },
                        { "filetype", icon = { align = "right" } },
                        {
                            function()
                                return require("modules.ui").python_venv_selector()
                            end,
                        },
                        { "filesize" },
                        {
                            "encoding",
                            -- Only show when encoding is not the default utf-8
                            cond = function()
                                local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
                                return enc ~= "utf-8"
                            end,
                        },
                    },
                    lualine_y = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        function()
                            return " " .. os.date("%I:%M, %a")
                        end,
                    },
                },
            })
        end,
    },
    {
        -- gives location tree inside a functions/class/structure.
        "SmiteshP/nvim-navic",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
    },
}
