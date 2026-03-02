local augroup = require("utils").augroup

-- 2-space indent for web/config filetypes (ecosystem convention)
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("two_space_indent"),
    pattern = {
        "css",
        "scss",
        "html",
        "json",
        "jsonc",
        "yaml",
        "toml",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
    },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- Makefile requires real tabs (syntax requirement)
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("makefile"),
    pattern = "make",
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
    end,
})

-- Terminal: clean UI, start in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup("terminal"),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.scrolloff = 0
        -- snacks dashboard renders terminal sections (gh notify, git diff, etc.)
        -- as real terminal buffers, triggering this autocmd and landing in insert
        -- mode on the dashboard. Skip startinsert when the dashboard is visible.
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "snacks_dashboard" then
                return
            end
        end
        vim.cmd("startinsert")
    end,
})

-- Read-only utility windows: no scrolloff context needed
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("no_scrolloff"),
    pattern = { "help", "man", "qf" },
    callback = function()
        vim.opt_local.scrolloff = 0
    end,
})

-- Git commit: conventional message width + start in insert
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("gitcommit"),
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.textwidth = 72
        vim.cmd("startinsert")
    end,
})

-- Disable spell in code filetypes (spell is on globally; not useful in code)
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("nospell_code"),
    pattern = {
        "lua",
        "python",
        "rust",
        "go",
        "c",
        "cpp",
        "java",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "sh",
        "bash",
        "css",
        "scss",
        "json",
        "jsonc",
        "yaml",
        "toml",
    },
    callback = function()
        vim.opt_local.spell = false
    end,
})
