local M = {}

-- copied from nvChad utils.
M.lazy_load = function(plugin)
	vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
		group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
		callback = function()
			local file = vim.fn.expand("%")
			local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""

			if condition then
				vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

				-- dont defer for treesitter as it will show slow highlighting
				-- This deferring only happens only when we do "nvim filename"
				if plugin ~= "nvim-treesitter" then
					vim.schedule(function()
						require("lazy").load({
							plugins = plugin,
						})

						if plugin == "nvim-lspconfig" then
							vim.cmd("silent! do FileType")
						end
					end, 0)
				else
					require("lazy").load({
						plugins = plugin,
					})
				end
			end
		end,
	})
end

---@param plugin string
function M.has(plugin)
	return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@type table<string,LazyFloat>
local terminals = {}
-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyCmdOptions|{interactive?:boolean, esc_esc?:false, ctrl_hjkl?:false}
function M.float_term(cmd, opts)
	opts = vim.tbl_deep_extend("force", {
		ft = "lazyterm",
		size = { width = 0.9, height = 0.9 },
	}, opts or {}, { persistent = true })
	---@cast opts LazyCmdOptions|{interactive?:boolean, esc_esc?:false}

	local termkey = vim.inspect({ cmd = cmd or "shell", cwd = opts.cwd, env = opts.env, count = vim.v.count1 })

	if terminals[termkey] and terminals[termkey]:buf_valid() then
		terminals[termkey]:toggle()
	else
		terminals[termkey] = require("lazy.util").float_term(cmd, opts)
		local buf = terminals[termkey].buf
		vim.b[buf].lazyterm_cmd = cmd
		if opts.esc_esc == false then
			vim.keymap.set("t", "<esc>", "<esc>", { buffer = buf, nowait = true })
		end
		if opts.ctrl_hjkl == false then
			vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = buf, nowait = true })
			vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = buf, nowait = true })
			vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = buf, nowait = true })
			vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = buf, nowait = true })
		end

		vim.api.nvim_create_autocmd("BufEnter", {
			buffer = buf,
			callback = function()
				vim.cmd.startinsert()
			end,
		})
	end

	return terminals[termkey]
end

function M.get_root()
	---@type string?
	local path = vim.api.nvim_buf_get_name(0)
	path = path ~= "" and vim.loop.fs_realpath(path) or nil
	---@type string[]
	local roots = {}
	if path then
		for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			local workspace = client.config.workspace_folders
			local paths = workspace
					and vim.tbl_map(function(ws)
						return vim.uri_to_fname(ws.uri)
					end, workspace)
				or client.config.root_dir and { client.config.root_dir }
				or {}
			for _, p in ipairs(paths) do
				local r = vim.loop.fs_realpath(p)
				if path:find(r, 1, true) then
					roots[#roots + 1] = r
				end
			end
		end
	end
	table.sort(roots, function(a, b)
		return #a > #b
	end)
	---@type string?
	local root = roots[1]
	if not root then
		path = path and vim.fs.dirname(path) or vim.loop.cwd()
		---@type string?
		root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
		root = root and vim.fs.dirname(root) or vim.loop.cwd()
	end
	---@cast root string
	return root
end

return M
