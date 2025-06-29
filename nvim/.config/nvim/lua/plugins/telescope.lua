local Utils = require("utils")

local config = function()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
    end
    local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
    end

    local function closePopup(prompt_bufnr)
        if vim.env.NVIM_TMUX_KEY then -- If NVIM_TMUX_KEY env is set. i.e. -> coming from tmux
            vim.cmd("qa!") -- Exit Neovim
        else
            actions.close(prompt_bufnr) -- Just close Telescope
        end
    end

    require("telescope").load_extension("fzf")
    require("telescope").setup({
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            sorting_strategy = "ascending",
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                },
            },
            file_ignore_patterns = {
                -- git file [No need as using gitfiles if git directory.]
                -- ".git/",
                -- python venv folders
                "venv/",
                ".venv/",
                "__pycache__/",
                "node_modules",
                ".obsidian",
            },
            -- open files in the first window that is an actual file.
            -- use the current window if no other window is available.
            get_selection_window = function()
                local wins = vim.api.nvim_list_wins()
                table.insert(wins, 1, vim.api.nvim_get_current_win())
                for _, win in ipairs(wins) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    if vim.bo[buf].buftype == "" then
                        return win
                    end
                end
                return 0
            end,
            mappings = {
                i = {
                    ["<c-t>"] = open_with_trouble,
                    ["<a-t>"] = open_selected_with_trouble,
                    ["<C-Down>"] = actions.cycle_history_next,
                    ["<C-Up>"] = actions.cycle_history_prev,
                    ["<C-w>"] = actions.preview_scrolling_down,
                    ["<C-s>"] = actions.preview_scrolling_up,
                    -- ["<CR>"] = closePopup,
                },
                n = {
                    ["q"] = closePopup,
                    ["<ESC>"] = closePopup,
                },
            },
            pickers = {
                find_files = {},
                live_grep = {
                    theme = "dropdown",
                    previewer = false,
                },
                buffers = {},
            },
        },
    })

    -- Keymaps (Currently using Snacks.Picker)
    -- local map = require("utils.keymapper").keymap
    -- local builtin = require("telescope.builtin")
    --
    -- if Utils.is_git_repository() then
    --     -- git
    --     map("n", "<leader><space>", function()
    --         builtin.git_files({ show_untracked = true })
    --     end, {
    --         desc = "Find git files",
    --     })
    --     map("n", "<leader>gc", "Telescope git_commits", {
    --         desc = "[G]it [c]ommits",
    --     })
    --     map("n", "<leader>gS", "Telescope git_status", {
    --         desc = "[G]it [S]tatus Telescope",
    --     })
    -- else
    --     map("n", "<leader><space>", builtin.find_files, {
    --         desc = "Find files",
    --     })
    -- end
    --
    -- map("n", "<leader>ff", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", {
    --     desc = "Find all files",
    -- })
    -- map("n", "<leader>fg", builtin.live_grep, {
    --     desc = "Find inside all Files | Live [g]rep",
    -- })
    -- map("n", "<leader>fw", builtin.grep_string, {
    --     desc = "find current [w]ord",
    -- })
    -- map("n", "<leader>fb", builtin.buffers, {
    --     desc = "Find [b]uffers",
    -- })
    -- map("n", "<leader>fh", builtin.help_tags, {
    --     desc = "find [H]elp page",
    -- })
    -- map("n", "<leader>?", builtin.oldfiles, {
    --     desc = "Find recently opened files/oldfiles",
    -- })
    -- map("n", "<leader>/", function()
    --     -- You can pass additional configuration to telescope to change theme, layout, etc.
    --     builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    --         -- winblend = 10,
    --         previewer = false,
    --     }))
    -- end, {
    --     desc = "Find in current buffer",
    -- })
    -- -- diagnostics/problems in file
    -- map("n", "<leader>fp", "Telescope diagnostics bufnr=0", {
    --     desc = "Diagnostics/[p]roblems[buffer]",
    -- })
    -- map("n", "<leader>fP", "Telescope diagnostics", {
    --     desc = "Diagnostics/[P]roblems[workspace]",
    -- })
    --
    -- -- LSP: SYMBOLS USING TELESCOPE
    -- map(
    --     "n",
    --     "<leader>sr",
    --     require("telescope.builtin").lsp_references,
    --     { des = "[s]earch [r]eferences -> cur @parameter" }
    -- )
    -- map("n", "<leader>ss", require("telescope.builtin").lsp_document_symbols, { desc = "[s]earch [s]ymbols -> buffer" })
    -- map(
    --     "n",
    --     "<leader>sw",
    --     require("telescope.builtin").lsp_dynamic_workspace_symbols,
    --     { desc = "[s]earch [S]ymbols -> workspace" }
    -- )
    --
    -- -- Other miscs
    -- map("n", '<leader>s"', "Telescope registers", { desc = "Registers" })
    -- map("n", "<leader>sa", "Telescope autocommands", { desc = "Auto Commands" })
    -- map("n", "<leader>sb", "Telescope current_buffer_fuzzy_find", { desc = "Buffer" })
    -- map("n", "<leader>sc", "Telescope command_history", { desc = "Command History" })
    -- map("n", "<leader>sC", "Telescope commands", { desc = "Commands" })
    -- map("n", "<leader>sh", "Telescope help_tags", { desc = "Help Pages" })
    -- map("n", "<leader>sH", "Telescope highlights", { desc = "Search Highlight Groups" })
    -- map("n", "<leader>sk", "Telescope keymaps", { desc = "Key Maps" })
    -- map("n", "<leader>sM", "Telescope man_pages", { desc = "Man Pages" })
    -- map("n", "<leader>sm", "Telescope marks", { desc = "Jump to Mark" })
    -- map("n", "<leader>so", "Telescope vim_options", { desc = "Options" })
    -- map("n", "<leader>sR", "Telescope resume", { desc = "Resume" })
end

return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    lazy = false,
    version = false, -- telescope did only one release, so use HEAD for now
    -- enabled = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            enabled = vim.fn.executable("make") == 1,
        },
    },
    config = config,
}
