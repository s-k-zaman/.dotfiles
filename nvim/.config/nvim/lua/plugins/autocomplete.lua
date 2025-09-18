local PluginUtils = require("utils.plugins")
return {
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            {
                -- snippet engine plugin
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = "rafamadriz/friendly-snippets", -- adds many extra snippets.
                config = function()
                    require("luasnip").config.set_config({
                        history = true,
                        updateevents = "TextChanged,TextChangedI",
                    })

                    -- vscode format
                    require("luasnip.loaders.from_vscode").lazy_load()
                    require("luasnip.loaders.from_vscode").lazy_load({
                        paths = vim.g.vscode_snippets_path or "",
                    })

                    -- snipmate format
                    require("luasnip.loaders.from_snipmate").load()
                    require("luasnip.loaders.from_snipmate").lazy_load({
                        paths = vim.g.snipmate_snippets_path or "",
                    })

                    -- lua format
                    require("luasnip.loaders.from_lua").load()
                    require("luasnip.loaders.from_lua").lazy_load({
                        paths = vim.g.lua_snippets_path or "",
                    })

                    vim.api.nvim_create_autocmd("InsertLeave", {
                        callback = function()
                            if
                                require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                                and not require("luasnip").session.jump_active
                            then
                                require("luasnip").unlink_current()
                            end
                        end,
                    })
                end,
            },
            -- cmp sources plugins
            {
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                -- "hrsh7th/cmp-emoji", -- USING sancks emoji

                "onsails/lspkind-nvim", --vscode like
            },
        },
        opts = function()
            vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
            local cmp = require("cmp")
            local defaults = require("cmp.config.default")()
            return {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-w>"] = cmp.mapping.scroll_docs(4),
                    ["<C-s>"] = cmp.mapping.scroll_docs(-4),
                    -- ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-c>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    -- ["<S-CR>"] = cmp.mapping.confirm({
                    --     behavior = cmp.ConfirmBehavior.Replace,
                    --     select = true,
                    -- }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    -- ["<C-CR>"] = function(fallback)
                    --     cmp.abort()
                    --     fallback()
                    -- end,
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif require("luasnip").expand_or_jumpable() then
                            vim.fn.feedkeys(
                                vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
                                ""
                            )
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif require("luasnip").jumpable(-1) then
                            vim.fn.feedkeys(
                                vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true),
                                ""
                            )
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                formatting = {
                    fields = { "abbr", "kind", "menu" },
                    format = function(entry, item)
                        -- VSCODE LIKE SETUP
                        if PluginUtils.has("lspkind-nvim") and USE_LSPKIND then
                            item = require("lspkind").cmp_format({
                                mode = "symbol_text",
                                before = function(kind_entry, kind_item)
                                    if PluginUtils.has("tailwind-tools") then
                                        kind_item = require("tailwind-tools.cmp").lspkind_format(kind_entry, kind_item)
                                    elseif PluginUtils.has("tailwindcss-colorizer-cmp.nvim") then
                                        kind_item = require("tailwindcss-colorizer-cmp").formatter(entry, item)
                                    end
                                    return kind_item
                                end,
                            })(entry, item)
                            return item
                        end

                        -- NORMAL SETUP
                        local icons = require("utils.glyphs").icons.kinds
                        local source_table_representation = {
                            nvim_lsp = "LSP",
                            path = "Path",
                            buffer = "Buf",
                        }
                        if icons[item.kind] then
                            item.kind = icons[item.kind] .. item.kind
                        end
                        item.menu = source_table_representation[entry.source.name] or entry.source.name
                        if PluginUtils.has("tailwindcss-colorizer-cmp.nvim") then
                            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
                        end
                        return item
                    end,
                },
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
                sorting = defaults.sorting,
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "nvim_lua" },
                    { name = "path" },
                    { name = "crates" },
                    -- { name = "emoji" }, -- USING Snacks emoji 
                }, {
                    { name = "buffer" },
                }),
            }
        end,
        config = function(_, opts)
            local cmp = require("cmp")
            for _, source in ipairs(opts.sources) do
                source.group_index = source.group_index or 1
            end
            if PluginUtils.has("nvim-autopairs") then
                local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end
            cmp.setup(opts)
        end,
    },
}
