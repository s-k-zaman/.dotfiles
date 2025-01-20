-- treat xhtml files as xml/html files, for better plugin support
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.xhtml",
    callback = function()
        -- vim.bo.filetype = "xml"
        vim.bo.filetype = "html" -- working best
    end,
})
