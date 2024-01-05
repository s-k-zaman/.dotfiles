-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
--------------------- DELETE KEYMAPS--------------
vim.keymap.del("n", "<leader>qq")

-------------- windows --------------
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>\\", "<C-W>v", { desc = "Split window right" })

-------------- tabs --------------
if Util.has("bufferline.nvim") then -- for any bufferline plugin.
  map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Tab" })
  map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Tab" })
else
  map("n", "<Tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  map("n", "<S-Tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
end

-- lazygit
-- keymap("n", "<leader>gg", function()
--   Util.terminal({ "gitlazy" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false })
-- end, { desc = "Lazygit (root dir)" })
-- keymap("n", "<leader>gG", function()
--   Util.terminal({ "gitlazy" }, { esc_esc = false, ctrl_hjkl = false })
-- end, { desc = "Lazygit (cwd)" })

------ terminal -------------
map("n", "<space>`", function()
  Util.terminal()
end, { desc = "Terminal (cwd)" })
map("t", "<space>`", "<cmd>close<cr>", { desc = "Hide Terminal" })
--------------------- my keymaps ------------------------------
-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "select all" })

-- scrolling page
map("n", "<C-w>", "<C-u>zz", { desc = "scroll up" })
map("n", "<C-s>", "<C-d>zz", { desc = "scroll down" })

-- This is going to get me cancelled(the primegean)
map("i", "<C-c>", "<Esc>")

-- greatest remap ever
map("x", "<leader>p", [["_dP]]) -- don't loose what i am pasting.

-- next greatest remap ever : asbjornHaland
-- not using as my clipboard is synced through set.lua file.
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]) -- same as y sync to system clipboard.
-- vim.keymap.set("n", "<leader>Y", [["+Y]]) -- same as yy, sync to system clipboard.
-- vim.keymap.set({ "n", "v" }, "<leadr>d", [["_d]]) -- same as d, sync to system clipboard.

-- leader + s does the same thing as below but with delay of few secs.
map(
  "n",
  "<leader>cw",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "change current word in full document." }
)

-------------other useful shortcuts--------------
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<leader>I", function()
  Util.format({ force = true })
end, { desc = "Fomat file(conform|lsp)" })

-- make bash script executable
map("n", "<leader>mx", "<cmd>!chmod +x %<CR>", {
  silent = true,
  desc = "make bash script executable",
})

---- search word silently ---------
map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")
--------------------------------------------------
