local M = {
  sysname = vim.loop.os_uname().sysname,
  venv_manager_default_paths = {
    Poetry = {
      Linux = "~/.cache/pypoetry/virtualenvs",
      Darwin = "~/Library/Caches/pypoetry/virtualenvs",
      Windows_NT = "%APPDATA%\\pypoetry\\virtualenvs",
    },
    Pipenv = {
      Linux = "~/.local/share/virtualenvs",
      Darwin = "~/.local/share/virtualenvs",
      Windows_NT = "~\\virtualenvs",
    },
    Pyenv = {
      Linux = "~/.pyenv/versions",
      Darwin = "~/.pyenv/versions",
      Windows_NT = "%USERPROFILE%\\.pyenv\\versions",
    },
    Hatch = {
      Linux = "~/.local/share/hatch/env/virtual",
      Darwin = "~/Library/Application/Support/hatch/env/virtual",
      Windows_NT = "%USERPROFILE%\\AppData\\Local\\hatch\\env\\virtual",
    },
    VenvWrapper = {
      Linux = "$HOME/.virtualenvs",
      Darwin = "$HOME/.virtualenvs",
      Windows_NT = "%USERPROFILE%\\.virtualenvs", -- VenvWrapper not supported on Windows but need something here
    },
    Conda = {
      Linux = "$CONDA_PREFIX/envs",
      Darwin = "$CONDA_PREFIX/envs",
      Windows_NT = "%CONDA_PREFIX%\\envs",
    },
  },
}

M.get_venv_manager_default_path = function(venv_manager_name)
  return M.venv_manager_default_paths[venv_manager_name][M.sysname]
end

M.get_python_parent_folder = function()
  if M.sysname == "Linux" or M.sysname == "Darwin" then
    return "bin"
  else
    return "Scripts"
  end
end

M.get_python_name = function()
  if M.sysname == "Linux" or M.sysname == "Darwin" then
    return "python"
  else
    return "python.exe"
  end
end

M.get_path_separator = function()
  if M.sysname == "Linux" or M.sysname == "Darwin" then
    return "/"
  else
    return "\\"
  end
end

M.get_info = function()
  --- @class SystemInfo
  --- @field sysname string System namme
  --- @field path_sep string Path separator appropriate for user system
  --- @field python_name string Name of Python binary
  --- @field python_parent_path string Directory containing Python binary on user system
  return {
    sysname = vim.loop.os_uname().sysname,
    path_sep = M.get_path_separator(),
    python_name = M.get_python_name(),
    python_parent_folder = M.get_python_parent_folder(),
  }
end

return M
