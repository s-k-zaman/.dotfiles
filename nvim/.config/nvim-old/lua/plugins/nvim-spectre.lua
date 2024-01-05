return {
	-- search and replace
	"nvim-pack/nvim-spectre",
	cmd = "Spectre",
	opts = { open_cmd = "noswapfile vnew" },
	config = function()
		vim.keymap.set("n", "<leader>cr", function()
			require("spectre").open()
		end, { desc = "Spectre: Replace in files" })
	end,
}
