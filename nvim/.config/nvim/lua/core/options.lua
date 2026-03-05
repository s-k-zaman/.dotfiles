vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

local opt = vim.opt

-- indentation
opt.tabstop = INDENT_SIZE
opt.softtabstop = INDENT_SIZE
opt.shiftwidth = INDENT_SIZE
opt.shiftround = true
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.wrap = false

-- search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- appearance
opt.number = true
opt.relativenumber = true
opt.laststatus = 3
opt.termguicolors = true
opt.scrolloff = SCROLL_OFF
opt.signcolumn = "yes" -- always show; prevents layout shift
opt.completeopt = "menuone,noinsert,noselect"
opt.colorcolumn = COLOR_COLUMN > 0 and tostring(COLOR_COLUMN) or ""
opt.cmdheight = 1
opt.pumblend = 10
opt.pumheight = 10
if TRANSPARENT then
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- behavior
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true
opt.backspace = "indent,eol,start"
opt.splitbelow = true
opt.splitright = true
if vim.fn.has("nvim-0.9.0") == 1 then
    opt.splitkeep = "screen"
    opt.shortmess:append({ C = true })
end
opt.autochdir = false
-- opt.iskeyword:append("-") -- treat 'this-word' as a single word
opt.mouse:append("a")
opt.fillchars = { eob = " " }
if SYNC_CLIPBOARD then
    opt.clipboard:append("unnamedplus")
end
opt.modifiable = true
opt.spell = SPELL_CHECK
opt.isfname:append("@-@")
opt.updatetime = 50
opt.autoread = AUTO_RELOAD

-- global feature flags (toggled via keymaps or :commands)
vim.g.autoformat = false -- auto-format on save (manual: <leader>I or :Format)
vim.g.autolint = true   -- auto-lint on save/read (toggle: <leader>ux)

-- disable unused providers for faster startup
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
end

vim.g.markdown_recommended_style = 0

-- undercurl support
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
