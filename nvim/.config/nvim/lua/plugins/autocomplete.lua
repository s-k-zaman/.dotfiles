local PluginUtils = require("utils.plugins")
return {
    {
        -- TODO: need to check this
        -- "kdheepak/cmp-latex-symbols",
    },
    {
        -- inspired from: https://github.com/vimichael/my-nvim-config/blob/main/lua/plugins/completions.lua
        "saghen/blink.cmp",
        version = "1.*",
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets",
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                config = function()
                    local luasnip = require("luasnip")

                    luasnip.config.setup({
                        history = true,
                        updateevents = "TextChanged,TextChangedI",
                        enable_autosnippets = true,
                    })

                    -- Load friendly-snippets (html !, react rfce/rafce, etc.)
                    require("luasnip.loaders.from_vscode").lazy_load()

                    -- Custom snippets
                    luasnip.add_snippets("all", require("snippets.global"))
                    luasnip.add_snippets("markdown", require("snippets.notes"))
                    luasnip.add_snippets("text", require("snippets.notes"))
                    luasnip.add_snippets("tex", require("snippets.latex"))
                    luasnip.add_snippets("html", require("snippets.html"))
                    luasnip.add_snippets("python", require("snippets.python"))
                    luasnip.add_snippets("javascript", require("snippets.javascript"))
                    luasnip.add_snippets("typescript", require("snippets.javascript"))
                    luasnip.add_snippets("javascriptreact", require("snippets.javascript"))
                    luasnip.add_snippets("typescriptreact", require("snippets.javascript"))
                    luasnip.add_snippets("lua", require("snippets.lua_snips"))
                end,
            },
            {
                "mikavilpas/blink-ripgrep.nvim",
                version = "*", -- use the latest stable version
            },
        },
        -- TODO: add tailwind color support, tailwind-tools.cmp
        ---@module 'blink.cmp'
        opts = {
            enabled = function()
                local disabled = false
                local buftype = vim.bo.buftype
                local filetype = vim.bo.filetype

                -- Disable blink.cmp conditionally
                -- if buftype == "nofile" then
                --     return disabled
                -- end
                if filetype == "DressingInput" then
                    return disabled
                end
                if buftype == "NvimTree" then
                    return disabled
                end

                return not disabled
            end,
            keymap = {
                preset = "enter",
                ["<CR>"] = { "select_and_accept", "fallback" },
                ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
                ["<C-b>"] = false,
                -- fill text of selected item without triggering LSP auto-actions
                ["<C-f>"] = {
                    function(cmp)
                        return cmp.select_next({ count = 0, auto_insert = true })
                    end,
                    "fallback",
                },
                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            },

            appearance = {
                nerd_font_variant = "mono",
            },
            signature = {
                enabled = true,
                window = {
                    show_documentation = false,
                },
            },
            completion = {
                list = {
                    selection = {
                        preselect = true,
                        auto_insert = false,
                    },
                },
                -- trigger = {
                -- INFO: need to explore this.....
                -- show_on_insert_on_trigger_character = false,
                -- show_on_accept_on_trigger_character = false,
                -- show_on_blocked_trigger_characters = { " ", "\n", "\t", "{", "(", "}", ")" },
                -- },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                    window = {
                        border = "double", -- single, double
                    },
                },
                ghost_text = {
                    enabled = true,
                    show_with_menu = true,
                },
                menu = {
                    auto_show = true,
                    scrollbar = false,
                    border = "single", -- single, double
                    draw = {
                        columns = {
                            { "source_name", "kind_icon", gap = 1 },
                            { "label", "label_description", gap = 1 },
                            { "kind", gap = 1 },
                        },
                    },
                },
            },
            snippets = {
                preset = "luasnip",
            },
            sources = {
                providers = {
                    snippets = {
                        name = "LuaSnip",
                    },
                    ripgrep = {
                        module = "blink-ripgrep",
                        name = "Ripgrep",
                        score_offset = -100000,
                        -- Disable per filetype/buffer
                        enabled = function()
                            return not vim.tbl_contains({ "txt", "markdown", "git" }, vim.bo.filetype)
                        end,
                        ---@module "blink-ripgrep"
                        ---@type blink-ripgrep.Options
                        opts = {
                            prefix_min_len = 4,
                            toggles = {
                                -- The keymap to toggle the plugin on and off from blink
                                on_off = "<leader>urg",
                            },
                            backend = {
                                use = "gitgrep", --"gitgrep-or-ripgrep",
                                ripgrep = {
                                    ignore_paths = {},
                                },
                            },
                        },
                    },
                },
                default = {
                    "lsp",
                    "path",
                    "buffer",
                    "snippets",
                    "ripgrep", -- searches whole project
                },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
        keys = {
            {
                "<leader>la",
                function()
                    vim.cmd("Lazy reload blink.cmp")
                    vim.notify("blink.cmp reloaded", vim.log.levels.INFO)
                end,
                desc = "Reload autocomplete (blink.cmp)",
            },
        },
    },
}
