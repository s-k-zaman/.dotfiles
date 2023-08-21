local utils = require "custom.modules.venv_selector_python.utils"
local config = require "custom.configs.venv_selector_python"
local custom_utils = require "custom.utils"
local system = require "custom.modules.venv_selector_python.system"
local sys_info = system.get_info()

local M = {
  current_venv = nil,
  venv_enabled = true,
}

M.find_venvs = function(directories, max_depth, names)
  -- TODO: remove duplicate entries if included folders
  local venv_list
  -- directories -> string or list of directories.
  if directories == "" or not directories then
    directories = { vim.fn.getcwd() }
  end
  if type(directories) == string then
    directories = { directories }
  end
  -- venv_dir_names -> string or list of names.
  if names == "" or not names then
    if config.settings.names ~= nil then
      names = config.settings.names
    else
      names = "pyvenv.cfg"
    end
  end
  -- set max depth for search
  local max_depth_string = ""
  if max_depth == false then
    max_depth_string = ""
  elseif
    type(max_depth) == "string"
    or max_depth == true
    or max_depth == 0
    or not max_depth
    or config.settings.fd_binary_depth_to_search < 1
  then
    max_depth = config.settings.fd_binary_depth_to_search or 2
    max_depth_string = "--maxdepth " .. max_depth
  else
    max_depth_string = "--maxdepth " .. max_depth
  end

  local search_path_string = utils.create_fd_search_path_string(directories)
  if search_path_string:len() ~= 0 then
    local names_path_regexp = utils.create_fd_venv_names_regexp(names)
    local cmd = config.settings.fd_binary_name
      .. " -HI --absolute-path --color never "
      .. max_depth_string
      .. " '"
      .. names_path_regexp
      .. "' "
      .. search_path_string
    utils.notify("searching venvs...")
    local file = assert(io.popen(cmd, "r"))
    local venvs = M.get_names_and_paths(file:lines()) -- venvs, only have {path}
    file:close()
    if #venvs > 0 then
      venvs = M.get_source_of_venvs(venvs)
    end
    utils.notify("Search complete.")
    venv_list = venvs
  else
    return false -- no venvs found
  end
  -- return ->  {{ path, name, source },{ path, name, source }}
  return venv_list
end

M.venv_with_relative_path = function(venv_list)
  if not venv_list then
    return
  end
  local success, Path = pcall(require, "plenary.path")
  if not success then
    vim.notify("Could not require plenary: " .. Path, vim.log.levels.WARN)
    return
  end
  local venv_list_rel = {}
  for _, venv in ipairs(venv_list) do
    if
      (custom_utils.clean_regex_from_string(venv.path)):find(custom_utils.clean_regex_from_string(vim.fn.getcwd()))
    then
      table.insert(venv_list_rel, {
        name = venv.name,
        source = venv.source,
        path = "./" .. Path:new(venv.path):make_relative(vim.fn.getcwd()),
      })
    else
      table.insert(venv_list_rel, {
        name = venv.name,
        source = venv.source,
        path = "~/" .. Path:new(venv.path):make_relative(vim.fn.expand "$HOME"),
      })
    end
  end
  return venv_list_rel
end

function M.get_names_and_paths(lines)
  local venv_with_name = {}
  local venv_with_path = {}
  -- 0. get all the paths in a table <-- absolute nessesarry.
  for row in lines do
    if row ~= "" then
      table.insert(venv_with_path, {
        path = utils.remove_last_slash(row),
      })
    end
  end
  -- 1. get all the names
  for _, venv_table in ipairs(venv_with_path) do
    local this_venv = {}
    local cmd = "cat " .. venv_table.path .. ' | grep "prompt"'
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
      this_venv.name = name
    else
      -- find the name by folder name
      local name = custom_utils.mysplit(venv_table.path, system.get_path_separator())
      name = name[#name - 1]
      this_venv.name = name
    end
    -- 2. get all the paths
    local path = venv_table.path
    if custom_utils.ends_with(path, "/") then
      this_venv.path = utils.remove_last_slash(path)
    else
      local names_table = custom_utils.mysplit(path, system.get_path_separator())
      local path_table = {}
      for i, string in ipairs(names_table) do
        if i < #names_table then
          table.insert(path_table, string)
        end
      end
      local path_string = table.concat(path_table, system.get_path_separator())
      this_venv.path = path_string
      -- add leading `/` in the path
      this_venv.path = "/" .. this_venv.path
      table.insert(venv_with_name, this_venv)
    end
  end
  return venv_with_name
end

M.get_source_of_venvs = function(venv_list_with_path_only)
  local venvs_with_source_and_name = {}
  local manager_sources = {}
  for k, _ in pairs(system.venv_manager_default_paths) do
    table.insert(manager_sources, k)
  end
  for _, venv in ipairs(venv_list_with_path_only) do
    local new_venv = {}
    new_venv.path = venv.path
    new_venv.name = venv.name
    -- getting source
    local is_manager_source = false
    for _, manager in ipairs(manager_sources) do
      local manager_path = system.get_venv_manager_default_path(manager)
      local expand_manager_path = vim.fn.expand(manager_path)
      if expand_manager_path ~= "" then
        -- check if path exist with the venv
        if
          (custom_utils.clean_regex_from_string(venv.path)):find(
            custom_utils.clean_regex_from_string(expand_manager_path)
          )
        then
          is_manager_source = true
          new_venv.source = manager
          break
        end
      end
    end

    if is_manager_source == false then
      new_venv.source = "In Folder"
    end
    -- appending to venvs_with_source_and_name
    table.insert(venvs_with_source_and_name, new_venv)
  end
  return venvs_with_source_and_name
end

local update_system_path = function(venv_path)
  local current_system_path = vim.fn.getenv "PATH"
  local prev_bin_path = M.current_venv.path .. sys_info.path_sep .. sys_info.python_parent_folder
  local new_bin_path = venv_path .. sys_info.path_sep .. sys_info.python_parent_folder

  -- Remove previous bin path from path
  if prev_bin_path ~= nil then
    current_system_path = string.gsub(current_system_path, utils.escape_pattern(prev_bin_path .. ":"), "")
  end

  -- Add new bin path to path
  local new_system_path = new_bin_path .. ":" .. current_system_path
  vim.fn.setenv("PATH", new_system_path)
end

M.get_python_path = function(venv_path)
  return venv_path .. sys_info.path_sep .. sys_info.python_parent_folder .. sys_info.path_sep .. sys_info.python_name
end

M.set_venv = function(venv, run_post_set_function)
  M.venv_enabled = true
  -- make paths full path -> Important
  if custom_utils.starts_with(venv.path, ".") then
    local path_split = custom_utils.mysplit(venv.path, sys_info.path_sep)
    path_split[1] = vim.fn.getcwd()
    venv.path = table.concat(path_split, sys_info.path_sep)
  end
  local return_item = {
    name = venv.name,
    path = venv.path,
    source = venv.source,
    python_path = M.get_python_path(venv.path),
  }
  -- if same venv do nothing
  if config.settings.allow_same_venv_selection ~= true then
    if M.current_venv ~= nil then
      if M.current_venv.path == venv.path then
        utils.notify("already selected -> " .. venv.name .. " (if you need to reload LSP, run :LspRestart)")
        return return_item
      end
    end
  end
  -- set paths accoording to source
  if venv.source == "Conda" then
    vim.fn.setenv("CONDA_PREFIX", venv.path)
    vim.fn.setenv("CONDA_DEFAULT_ENV", venv.name)
    vim.fn.setenv("CONDA_PROMPT_MODIFIER", "(" .. venv.name .. ")")
  else
    -- default set
    vim.fn.setenv("VIRTUAL_ENV", venv.path)
  end
  -- set current venv
  M.current_venv = venv
  update_system_path(venv.path)
  if config.settings.post_set_function and run_post_set_function ~= false then
    config.settings.post_set_function(return_item)
  end
  return return_item
end

M.unset_venv = function(run_post_set_function)
  if M.current_venv == nil then
    return
  end
  -- Remove previous bin path from path
  local current_system_path = vim.fn.getenv "PATH"
  local prev_bin_path = M.current_venv.path .. sys_info.path_sep .. sys_info.python_parent_folder

  if prev_bin_path ~= nil then
    current_system_path = string.gsub(current_system_path, utils.escape_pattern(prev_bin_path .. ":"), "")
    vim.fn.setenv("PATH", current_system_path)
  end
  -- Remove VIRTUAL_ENV environment variable.
  vim.fn.setenv("VIRTUAL_ENV", nil)
  -- running post set function
  if config.settings.post_set_function and run_post_set_function ~= false then
    config.settings.post_set_function(nil)
  end
  M.current_venv = nil
  M.venv_enabled = false
end

M.select_your_venv = function(venv_list)
  venv_list = M.venv_with_relative_path(venv_list)
  if not venv_list then
    return
  end
  local to_disable = "------ Disable Virtual Environment ---------"
  if M.current_venv ~= nil then
    table.insert(venv_list, { name = "    ", path = to_disable, source = "" })
  end
  vim.ui.select(venv_list, {
    prompt = "Select python venv",
    format_item = function(item)
      return string.format("%s [%s] (%s) ", item.name, item.source, item.path)
    end,
  }, function(choice)
    if not choice then
      return
    elseif choice.path == to_disable then
      M.unset_venv()
    else
      M.set_venv(choice)
    end
  end)
end

M.set_current_venv = function(venv_or_nill)
  M.current_venv = venv_or_nill
end

M.get_venv_status = function()
  return M.venv_enabled
end

return M
