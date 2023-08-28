local M = {}
M.get_lsps = function()
	local lsps = {}
	local return_str = ""
	local is_null_ls = false

	if rawget(vim, "lsp") then
		local lsp_servers = vim.lsp.get_active_clients()
		if #lsp_servers == 0 then
			return return_str
		end
		for _, client in ipairs(lsp_servers) do
			if client.name == "null-ls" then
				is_null_ls = true
			end
			if client.attached_buffers[vim.api.nvim_get_current_buf()] and client.name ~= "null-ls" then
				table.insert(lsps, client.name)
				-- return (vim.o.columns > 100 and "%#St_LspStatus#" .. "   LSP ~ " .. client.name .. " ")
				-- or "   LSP "
			end
		end
	else
		return return_str
	end

	if is_null_ls == true then
		local status, null_ls = pcall(require, "null-ls")
		if status then
			local curr_filetype = vim.bo.filetype
			local all_sources = null_ls.get_sources()
			for _, client in ipairs(all_sources) do
				if client.filetypes[curr_filetype] == true then
					table.insert(lsps, client.name)
				end
			end
		end
	end

	if #lsps == 0 then
		return_str = "%#Exception#" .. " LSP"
	elseif #lsps > 3 then
		return_str = "%#Label#" .. "(" .. table.concat(lsps, ", ", 1, 3) .. "..." .. ")"
	else
		return_str = "%#Label#" .. "(" .. table.concat(lsps, ", ") .. ")"
	end
	return return_str
end

return M
