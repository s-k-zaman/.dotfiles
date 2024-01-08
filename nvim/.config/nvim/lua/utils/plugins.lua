local M = {}

---@param plugin string
M.has = function(plugin)
	return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

return M
