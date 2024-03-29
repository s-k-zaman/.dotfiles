local Util = require("utils.lazy_nvim")

local function map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	---@cast keys LazyKeysHandler
	-- do not create the keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		if opts.remap and not vim.g.vscode then
			opts.remap = nil
		end
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

-- better up/down
-- map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- following is for netrw file explorer. disabled bicause using nvim-tree.
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })
-- map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
-- map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- do indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
vim.keymap.set("n", "J", "mzJ`z")

---- search word silently ---------
map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")
----------------------------------

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
vim.keymap.set("n", "Q", "<nop>")

-- vim.keymap.set("n", "<leader>vwm", function()
--    require("vim-with-me").StartVimWithMe()
-- end)
-- vim.keymap.set("n", "<leader>svwm", function()
--    require("vim-with-me").StopVimWithMe()
-- end)

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / clear hlsearch / diff update" }
)

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

--keywordprg
-- map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
	map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- quickfix and location.
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
-- these are for quickfix list.
-- have mapping overlap, CURRETNLY NOT USING.
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
-- if trouble plugin installed.
if not Util.has("trouble.nvim") then
	map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
	map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
end

-- quit vim , exiting all
-- map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-------------- files --------------
-- new file
-- map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- save file
-- map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-------------- windows --------------
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w\\", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>\\", "<C-W>v", { desc = "Split window right", remap = true })

if not Util.has("vim-tmux-navigator") then
	-- Move to window using the <ctrl> hjkl keys
	map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
	map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
	map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
	map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
end

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-------------- tabs --------------
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })

if Util.has("bufferline.nvim") then -- for any bufferline plugin.
	map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Tab" })
	map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Tab" })
else
	map("n", "<Tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
	map("n", "<S-Tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
end
-------------- buffers --------------
-- if Util.has("bufferline.nvim") then -- for any bufferline plugin.
-- 	map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
-- 	map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
-- 	map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
-- 	map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
-- else
-- 	map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
-- 	map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
-- 	map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
-- 	map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
-- end
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
-- Switch buffer
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

---------------terminals----------------
-- floating terminal
local lazyterm = function()
	Util.float_term(nil, { cwd = Util.get_root() })
end
map("n", "<leader>ft", lazyterm, { desc = "Terminal (root dir)" })
map("n", "<leader>fT", function()
	Util.float_term()
end, { desc = "Terminal (cwd)" })
map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-------------other useful shortcuts--------------
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>I", "<cmd>Format<CR>")

-- make bash script executable
vim.keymap.set("n", "<leader>mx", "<cmd>!chmod +x %<CR>", {
	silent = true,
	desc = "make bash script executable",
})

-- vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/zaman/packer.lua<CR>");
