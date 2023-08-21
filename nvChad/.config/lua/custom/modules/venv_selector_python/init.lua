-- inspired from
-- swenv -> https://github.com/AckslD/swenv.nvim
-- venv-selector -> https://github.com/linux-cultist/venv-selector.nvim
--
-- configuration file is in custom/configs/venv_selector_python.lua

local venv = require "custom.modules.venv_selector_python.venv"
local config = require "custom.configs.venv_selector_python"
local utils = require "custom.modules.venv_selector_python.utils"
local M = {}

M.pick_venv = function()
  local found_venvs = venv.find_venvs(config.pick_venv_folders)
  if found_venvs == false or not found_venvs or #found_venvs == 0 then
    return
  else
    venv.select_your_venv(found_venvs)
  end
end

M.pick_from_all_venvs = function()
  local found_venvs = venv.find_venvs(config.pick_from_all_folders, false)
  if found_venvs == false or not found_venvs or #found_venvs == 0 then
    return
  else
    venv.select_your_venv(found_venvs)
  end
end

M.try_set_in_folder_venv = function(run_post_set_function)
  if not run_post_set_function then
    run_post_set_function = false
  end

  local found_venvs = venv.find_venvs()
  if found_venvs == false or not found_venvs or #found_venvs == 0 then
    utils.notify "No Virtual Environment in current folder, Try selecting one Manually."
    return false
  else
    return venv.set_venv(found_venvs[1], run_post_set_function)
  end
end

M.get_current_venv = function()
  return venv.current_venv
end

M.set_current_venv = function(venv_or_nill)
  venv.set_current_venv = venv_or_nill
end

M.get_venv_status = function()
  return venv.get_venv_status()
end
M.make_python_path = function(venv_path)
  if not venv_path then
    return
  end
  return venv.get_python_path(venv_path)
end
return M
