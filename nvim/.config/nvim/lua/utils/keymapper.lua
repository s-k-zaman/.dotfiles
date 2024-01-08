local Util = require("utils")

local default_opts = {
	noremap = true,
	silent = true,
}

--- @param opts (table|nil)
--- @return table
local get_opts = function(opts)
	local all_opts = opts
	if all_opts == nil then
		all_opts = {}
	end
	for k, v in pairs(default_opts) do
		all_opts[k] = all_opts[k] or v
	end
	return all_opts
end

--- @param vimmode (string|table|nil)
--- @return string
local get_mode = function(vimmode)
	if vimmode == nil then
		return "n"
	else
		return vimmode
	end
end

--- @param command (string)
--- @return string
local get_cmd_string = function(command)
	if type(command) == "string" then
		if Util.starts_with(command, "<") or Util.starts_with(command, ":") then
			return command
		end
		return [[<cmd>]] .. command .. [[<CR>]]
	else
		return command
	end
end

--- @param keymaps (string|table)
--- @param command (string |function)
--- @param vimmode (string|table|nil)
--- @param options (table|nil)
--- @return nil
local keymap = function(vimmode, keymaps, command, options)
	local mode = get_mode(vimmode)
	local lhs = keymaps
	local rhs = nil
	if type(command) == "function" then
		rhs = command
	else
		rhs = get_cmd_string(command)
	end
	local opts = get_opts(options)
	vim.keymap.set(mode, lhs, rhs, opts)
end

return { keymap = keymap }
