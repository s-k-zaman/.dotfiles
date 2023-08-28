local M = {}
M.python_venv = function(only_string, full_name)
  if full_name == true then
    full_name = true
  else
    full_name = nil
  end

  local env = require("modules.venv_selector_python").get_current_venv()

  if env then
    local name = env["name"]
    if string.len(name) > 23 and not full_name then
      name = string.sub(name, 0, 23) .. "..."
    end
    if only_string == true then
      return "󰆧(" .. name .. ")"
    end
    return "%#Boolean#" .. "󰆧(" .. name .. ")"
  end

  return ""
end

return M
