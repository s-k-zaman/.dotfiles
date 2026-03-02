local augroup = require("utils").augroup

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("python"),
    pattern = "python",
    callback = function()
        -- ruff/black default line length
        vim.opt_local.colorcolumn = "88"
        vim.opt_local.textwidth = 88
    end,
})
