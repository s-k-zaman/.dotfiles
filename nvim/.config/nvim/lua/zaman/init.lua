require("zaman.set")
require("zaman.remap")
require("zaman.lazy")

local augroup = vim.api.nvim_create_augroup
local ZamanGroup = augroup('Zaman', {})
local yank_group = augroup('HighlightYank', {})
local pythonGroup = augroup('Python', { clear = true })

local autocmd = vim.api.nvim_create_autocmd

function R(name)
    require("plenary.reload").reload_module(name)
end

-- TODO: move this below autocmd to specified python.lua config file.
autocmd('BufWinEnter', {
    group = pythonGroup,
    pattern = '*.py',
    callback = function()
        --running programs
        vim.keymap.set("n", "<F5>",
            "<cmd>w<CR><cmd>silent !tmux neww bash -c \"python %;echo '';echo 'Done.';echo 'Ctrl+c to exit';while [ : ]; do sleep 1; done\"<CR>",
            {
                silent = true,
            })
    end
}
)

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = ZamanGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
