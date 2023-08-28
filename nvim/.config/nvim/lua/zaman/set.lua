-- fat curson on insert mode.
-- vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false -- Disable line wrap

vim.g.transparency = true

vim.opt.pumblend = 10 -- Popup blend
vim.opt.conceallevel = 3 -- Hide * markup for bold and italic
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
if vim.fn.has("nvim-0.9.0") == 1 then
	vim.opt.splitkeep = "screen"
	vim.opt.shortmess:append({ C = true })
end

-- sync with system clipboard/ allow copy pasting.
vim.opt.clipboard = "unnamedplus"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time.
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"
vim.opt.fillchars = { eob = " " }

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect"

vim.opt.winbar = "%=%m %f" -- shows file name in top right corner
vim.o.lazyredraw = false

-- disable some default providers
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
