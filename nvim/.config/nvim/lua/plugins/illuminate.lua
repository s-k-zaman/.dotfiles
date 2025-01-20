return {
    "RRethy/vim-illuminate",
    lazy = false,
    config = function()
        require("illuminate").configure({
            delay = 200,
            providers = {
                "lsp",
                -- "treesitter",
                -- "regex",
            },
        })
        local function map(key, dir, buffer)
            local is_endless = true
            vim.keymap.set("n", key, function()
                require("illuminate")["goto_" .. dir .. "_reference"](is_endless)
            end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference (illuminate)", buffer = buffer })
        end

        map("[[", "next")
        map("]]", "prev")

        -- -- lazyvim: also set it after loading ftplugins, since a lot overwrite [[ and ]]
        -- vim.api.nvim_create_autocmd("FileType", {
        --     callback = function()
        --         local buffer = vim.api.nvim_get_current_buf()
        --         map("]]", "next", buffer)
        --         map("[[", "prev", buffer)
        --     end,
        -- })
    end,
}
