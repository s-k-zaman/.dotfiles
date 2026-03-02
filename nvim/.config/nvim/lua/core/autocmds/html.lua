-- treat xhtml as html for better plugin support
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.xhtml",
    callback = function()
        vim.bo.filetype = "html"
    end,
})
