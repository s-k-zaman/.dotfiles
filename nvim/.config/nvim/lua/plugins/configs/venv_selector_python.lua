-- this is custom modules configuration, return is needed.
local system = require("modules.venv_selector_python.system")

local Config = {}

-- Default settings if user is not setting anything in setup() call
Config.settings = {
	names = "pyvenv.cfg",
	allow_same_venv_selection = false,
	fd_binary_name = "fdfind", -- or fd in other systems
	fd_binary_depth_to_search = 2, -- 2->current folder, 4->subfolders of current folder. Basically give multiple of two. WILL TAKE EFFECT IN MINIMAL SELECTION.
	-- managers
	poetry_path = system.get_venv_manager_default_path("Poetry"),
	pipenv_path = system.get_venv_manager_default_path("Pipenv"),
	pyenv_path = system.get_venv_manager_default_path("Pyenv"),
	conda_path = system.get_venv_manager_default_path("Conda"),
	venvwrapper_path = system.get_venv_manager_default_path("VenvWrapper"),
	hatch_path = system.get_venv_manager_default_path("Hatch"),
	-- other settings
	enable_debug_output = false, -- needed for debugging

	post_set_function = function() -- will run after successfull activation or deactivation.
		-- this function recives an argumnet `current_venv`,its either `nil` or `{name, path, source, python_path}`
		vim.cmd("LspRestart")
	end,
}
------folders to look for--------
Config.pick_venv_folders = {
	vim.fn.getcwd(),
	Config.settings.poetry_path,
}

Config.pick_from_all_folders = {
	-- have no --maxdepth limit
	vim.fn.getcwd(),
	-- vim.fn.expand "$HOME", -- will take long time.
	Config.settings.poetry_path,
	Config.settings.conda_path,
	Config.settings.hatch_path,
	Config.settings.pyenv_path,
	Config.settings.pipenv_path,
	Config.settings.venvwrapper_path,
	-- other folders
	"~/Courses",
	"~/work",
	"~/projects",
}
-----------------------------------

return Config
