-- set space as leader.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", {
	silent = true,
})

local opt = vim.opt

-- Tab/indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.wrap = false -- Disable line wrap

-- search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- appearance
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time.
opt.completeopt = "menuone,noinsert,noselect"
opt.colorcolumn = "80"
opt.cmdheight = 1
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
-- vim.opt.winbar = "%=%m %f" -- shows filename in top right corner

-- behavior
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true
opt.backspace = "indent,eol,start"
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
if vim.fn.has("nvim-0.9.0") == 1 then
	opt.splitkeep = "screen"
	opt.shortmess:append({ C = true })
end
opt.autochdir = false
opt.iskeyword:append("-")
opt.mouse:append("a")
opt.fillchars = { eob = " " }
opt.clipboard:append("unnamedplus")
opt.modifiable = true
--opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
--opt.encoding = "UTF-8"
opt.spell = true
opt.lazyredraw = false
opt.isfname:append("@-@")
opt.updatetime = 50
vim.g.autoformat = false

-- disable some default providers
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
