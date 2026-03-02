local augroup = require("utils").augroup

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("bash"),
    pattern = "sh",
    callback = function()
        vim.keymap.set("n", "<leader>mx", "<cmd>!chmod +x %<CR>", {
            silent = true,
            buffer = true,
            desc = "Make script executable",
        })
    end,
})
