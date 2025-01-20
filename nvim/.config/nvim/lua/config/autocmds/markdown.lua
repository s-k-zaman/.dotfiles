-- Set conceallevel for Markdown files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.wo.conceallevel = 2 -- Adjust conceallevel (0, 1, 2, or 3)
    end,
})
