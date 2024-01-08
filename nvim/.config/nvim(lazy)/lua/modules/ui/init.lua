local custom_utils = require("utils")
local system = require("modules.venv_selector_python.system")
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

M.python_venv_selector = function(only_string, full_name)
  local venv_name = nil
  local directory_path = require("venv-selector").get_active_venv()
  if directory_path then
    local path = directory_path .. "/pyvenv.cfg"
    local cmd = "cat " .. path .. ' | grep "prompt"'
    -- get grep results
    local results = {}
    local file = assert(io.popen(cmd, "r"))
    for row in file:lines() do
      if row ~= "" then
        table.insert(results, row)
      end
    end
    file:close()
    if #results > 0 then
      -- find the name from first line item
      local name = custom_utils.mysplit(results[1], "=")
      name = name[#name]
      name = string.gsub(name, "^%s*(.-)%s*$", "%1")
      venv_name = name
    else
      -- find the name by folder name
      local name = custom_utils.mysplit(path, system.get_path_separator())
      name = name[#name - 1]
      venv_name = name
    end
  end

  if venv_name then
    if string.len(venv_name) > 23 and not full_name then
      venv_name = string.sub(venv_name, 0, 23) .. "..."
    end
    if only_string == true then
      return "󰆧(" .. venv_name .. ")"
    end
    return "%#Boolean#" .. "󰆧(" .. venv_name .. ")"
  end

  return ""
end

return M
