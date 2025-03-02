---@diagnostic disable: undefined-global
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- enabled = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        dashboard = require("plugins.snacks.dashboard"),
        notifier = require("plugins.snacks.notifier"),
        lazygit = require("plugins.snacks.git"),
        explorer = require("plugins.snacks.explorer"),
        picker = require("plugins.snacks.picker"),
        -- indent = { enabled = true },
        -- input = { enabled = true },
        quickfile = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        -- words = { enabled = true },
        -- STYLES: of each component
        styles = {},
    },
    -- stylua: ignore start
    keys = {
        { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode", },
        { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom", },
        { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer", },
        { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer", },
        { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History", },
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer", },
        { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", },
        { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" }, },
        { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line", },
        { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History", },
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit", },
        { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)", },
        { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications", },
        { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal", },
        { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore", },
        { "]r", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference(LSP)", mode = { "n", "t" }, },
        { "[r", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference(LSP)", mode = { "n", "t" }, },

        -- SNACKS PICKER
        { "<leader><space>", function() Snacks.picker.smart({multi = {"buffers", "files"}}) end, desc = "Find Files (smart)" },
        { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>/", function() Snacks.picker.lines() end, desc = "Search Lines in Buffer" },

        -- f=> files, s=> search
        { "<leader>ff", function() Snacks.picker.files({ hidden = true, ignored = true, follow = true }) end, desc = "Find Files (All)" },
        { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files (all sessions)" },
        -- TODO: remove emoji-cmp from cmp-lists: emoji from typing `:`
        { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
        { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep search in Files" },
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Search Lines in Buffer" },
        { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
        { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },

        { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },

        -- LSP
        { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },--TODO: not working/know more
        { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },--TODO: not working/know more
        { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },--TODO: not working/know more
        { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

        -- miscs
        { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
        { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>sk", function() Snacks.picker.keymaps({ layout = "ivy" }) end, desc = "Keymaps" },
        { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
        { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },


        { "<leader>se", function() Snacks.explorer() end, desc = "File Explorer" },
    },
    -- stylua: ignore end
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.line_number():map("<leader>ul")
                Snacks.toggle
                    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                    :map("<leader>uc")
                Snacks.toggle.treesitter():map("<leader>uT")
                Snacks.toggle
                    .option("background", { off = "light", on = "dark", name = "Dark Background" })
                    :map("<leader>ub")
                Snacks.toggle.inlay_hints():map("<leader>uh")
                Snacks.toggle.indent():map("<leader>ug")
                Snacks.toggle.dim():map("<leader>uD")
            end,
        })
    end,
}
