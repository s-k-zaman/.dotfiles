vim.keymap.set("n", "<leader>cr", function()
	require("spectre").open()
end, { desc = "Spectre: Replace in files" })
