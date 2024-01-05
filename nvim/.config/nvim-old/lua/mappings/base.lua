-- Setting it before plugin keymaps.

-- set space as leader.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", {
	silent = true,
})

-- for escape out of insert mode
-- currently set by a plugin
-- vim.keymap.set("i", "jk", "<Esc>")
-- vim.keymap.set("i", "kj", "<Esc>")

-- scrolling page
vim.keymap.set("n", "<C-w>", "<C-u>zz", { desc = "scroll up" })
vim.keymap.set("n", "<C-s>", "<C-d>zz", { desc = "scroll down" })

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]]) -- don't loose what i am pasting.

-- reload neovim
-- re-source nvim configs
function Reload()
	vim.cmd(":source $NVIM_CONFIG")
	print("re-sourced configs")
end
vim.keymap.set("n", "<leader>rr", function()
	Reload()
end, { desc = "re-source configs" })

-- next greatest remap ever : asbjornHaland
-- not using as my clipboard is synced through set.lua file.
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]) -- same as y sync to system clipboard.
-- vim.keymap.set("n", "<leader>Y", [["+Y]]) -- same as yy, sync to system clipboard.
-- vim.keymap.set({ "n", "v" }, "<leadr>d", [["_d]]) -- same as d, sync to system clipboard.

-- leader + s does the same thing as below but with delay of few secs.
vim.keymap.set(
	"n",
	"<leader>cw",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "change current word in full document." }
)

-- call the disciplines
require("utils.discipline").cowboy()
