local map = require("utils.keymapper").keymap

vim.keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "select all" })
-- scrolling page
-- vim.keymap.set("n", "<C->", "<C-u>zz", { desc = "scroll up" })
-- vim.keymap.set("n", "<C->", "<C-d>zz", { desc = "scroll down" })

-- INFO: I think i don't need this[swapped esc with caps]
-- This is going to get me cancelled
-- vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "k", "gk", { desc = "move up" })
vim.keymap.set("n", "j", "gj", { desc = "move down" })
-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "paste[keep content]" }) -- don't loose what i am pasting.
vim.keymap.set(
    "n",
    "<leader>rw",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "change word (buf)" }
)

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })
-- do indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("n", "J", "mzJ`z")
---- search word silently ---------
vim.keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
map("n", "Q", "<nop>")
-- quickfix and location.
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
-- Inspect position of cursor
if vim.fn.has("nvim-0.9.0") == 1 then
    vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end
-------------- windows --------------
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
vim.keymap.set("n", "<leader>w\\", "<C-W>v", { desc = "Split window right" })
-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "resize +2", { desc = "Increase window height" })
map("n", "<C-Down>", "resize -2", { desc = "Decrease window height" })
map("n", "<C-Left>", "vertical resize -2", { desc = "Decrease window width" })
map("n", "<C-Right>", "vertical resize +2", { desc = "Increase window width" })
-------------- tabs --------------
map("n", "<leader><tab>o", "tablast", { desc = "Last Tab" })
map("n", "<leader><tab>O", "tabfirst", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "tabnew", { desc = "New Tab" })
map("n", "<leader><tab>h", "tabprevious", { desc = "Previous Tab" })
map("n", "<leader><tab>l", "tabnext", { desc = "Next Tab" })
map("n", "<leader><tab>d", "tabclose", { desc = "Close Tab" })
--------------buffers--------------
map("n", "<leader>bl", "bnext", { desc = "Next buffer", noremap = false, remap = true })
map("n", "<leader>bh", "bprevious", { desc = "Prev buffer", noremap = false, remap = true })
map("n", "<tab><tab>", "e #", { desc = "Switch to Other Buffer" })

map("n", "<leader>I", "Format", { desc = "Format File (conform|lsp)" })

------------- Toggles -----------------
vim.api.nvim_set_keymap("n", "<leader>tz", ":set wrap!<CR>", { desc = "toggle: word wrap", noremap = true })

------------- nb Note -----------------
map("n", "<leader>nr", "<cmd>!nb sync<cr>", { desc = "nb sync" })
--  TODO: escape # symbol
map(
    "n",
    "<leader>na",
    '<cmd>!tmux neww -c "#{pane_current_path}" "note-accessor"<cr>',
    { desc = "note-accessor", silent = true }
)
