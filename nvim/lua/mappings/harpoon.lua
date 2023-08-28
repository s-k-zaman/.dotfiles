-- Loaded through plugin configuration
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "harpoon: add this file" })
vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu, { desc = "harpoon: toggle menu" })

vim.keymap.set("n", "<C-m>", function()
	ui.nav_file(1)
end, { desc = "harpoon: file 1" })
vim.keymap.set("n", "<C-n>", function()
	ui.nav_file(2)
end, { desc = "harpoon: file 2" })
vim.keymap.set("n", "<C-i>", function()
	ui.nav_file(3)
end, { desc = "harpoon: file 3" })
vim.keymap.set("n", "<C-o>", function()
	ui.nav_file(4)
end, { desc = "harpoon: file 4" })
