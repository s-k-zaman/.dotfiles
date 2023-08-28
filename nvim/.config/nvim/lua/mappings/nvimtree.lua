-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- remap for toggle
vim.keymap.set("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", {desc = "toggle file explorer"})
