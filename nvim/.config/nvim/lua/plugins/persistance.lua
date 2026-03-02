return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
	init = function()
		-- NvimTree buffers are saved in the session as "NvimTree_1" etc.
		-- On restore they open as blank regular buffers (not real file paths).
		-- api.tree.is_visible() returns false at this point, so we scan by
		-- buffer name directly and close + wipe any such windows/buffers.
		vim.api.nvim_create_autocmd("SessionLoadPost", {
			callback = function()
				vim.schedule(function()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						local name = vim.api.nvim_buf_get_name(buf)
						local ft = vim.bo[buf].filetype
						if name:match("NvimTree_") or ft == "NvimTree" then
							pcall(vim.api.nvim_win_close, win, true)
							pcall(vim.api.nvim_buf_delete, buf, { force = true })
						end
					end
				end)
			end,
		})
	end,
	keys = {
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Restore Session",
		},
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore Last Session",
		},
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "Don't Save Current Session",
		},
	},
}
