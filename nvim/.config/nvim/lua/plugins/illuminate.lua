return {
    "RRethy/vim-illuminate",
    event = "LspAttach",
    config = function()
        require("illuminate").configure({
            delay = 200,
            providers = { "lsp" },
        })

        -- These are global keymaps; they register after LspAttach fires (first LSP client)
        local function map(key, dir)
            vim.keymap.set("n", key, function()
                require("illuminate")["goto_" .. dir .. "_reference"](true)
            end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference (illuminate)" })
        end
        map("[[", "next")
        map("]]", "prev")
    end,
}
