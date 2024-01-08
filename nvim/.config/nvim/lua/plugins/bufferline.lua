local map = require("utils.keymapper").keymap

return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			mode = "tabs",
			-- separator_style = "slant",
			show_buffer_close_icons = false,
			show_close_icon = false,
		},
	},
	config = function(_, opts)
		map("n", "<S-l>", "BufferLineCycleNext", { desc = "Next Tab" })
		map("n", "<S-h>", "BufferLineCyclePrev", { desc = "Prev Tab" })
		require("bufferline").setup(opts)
	end,
}
