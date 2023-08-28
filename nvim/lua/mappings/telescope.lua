-- keymaps
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader><space>", builtin.find_files, {
	desc = "Find files",
})
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", {
	desc = "Find all files",
})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
	desc = "Find inside all Files | Live [g]rep",
})

vim.keymap.set("n", "<leader>fw", builtin.grep_string, {
	desc = "find current [w]ord",
})

vim.keymap.set("n", "<leader>fb", builtin.buffers, {
	desc = "Find [b]uffers",
})

vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
	desc = "find [H]elp page",
})
vim.keymap.set("n", "<leader>?", builtin.oldfiles, {
	desc = "Find recently opened files/oldfiles",
})
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		-- winblend = 10,
		previewer = false,
	}))
end, {
	desc = "Find in current buffer",
})

-- git
vim.keymap.set("n", "<leader>gf", builtin.git_files, {
	desc = "Find [G]it [f]iles",
})

vim.keymap.set("n", "<leader>gc", "Telescope git_commits", {
	desc = "[G]it [c]ommits",
})
vim.keymap.set("n", "<leader>gs", "Telescope git_status", {
	desc = "[G]it [s]tatus",
})

-- diagnostics/problems in file

vim.keymap.set("n", "<leader>fp", builtin.diagnostics, {
	desc = "Search Diagnostics/[P]roblems",
})
