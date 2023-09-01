local augroup = vim.api.nvim_create_augroup
local pythonGroup = augroup("Python", { clear = true })
local autocmd = vim.api.nvim_create_autocmd
local venv_selctor_python = require "modules.venv_selector_python"

autocmd("BufWinEnter", {
  group = pythonGroup,
  pattern = "*.py",
  callback = function()
    --running programs using F5
    vim.keymap.set("n", "<F5>", function()
      --save file
      vim.cmd "w"
      -- then run with available sources
      local current_venv = venv_selctor_python.get_current_venv()
      if current_venv ~= nil then
        -- source virtual environment then run
        local venv_path = current_venv.path
        local venv_name = current_venv.name
        local venv_activation_path = venv_path .. "/bin/activate"
        vim.cmd(
          'silent !tmux neww bash -c "source '
            .. venv_activation_path
            .. ";echo 'in virtual env ->"
            .. venv_name
            .. "';echo '----------- running program --------------';"
            .. "python %;echo '';echo 'Done.';echo 'Ctrl+c to exit'"
            .. ';while [ : ]; do sleep 1; done"'
        )
      else
        local python_path = vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
        if not python_path then
          vim.notify(
            "Error: No python path found, Install it.",
            vim.log.levels.ERROR,
            { title = "Failed to run python program" }
          )
          return
        end
        vim.cmd(
          'silent !tmux neww bash -c "'
            .. "echo 'python-> "
            .. python_path
            .. "';"
                    .. "echo '________________________';"
            .. python_path
            .. " %;echo '';echo 'Done.';echo 'Ctrl+c to exit';while [ : ]; do sleep 1; done\""
        )
      end
    end, {
      silent = true,
    })

    vim.keymap.set("n", "<F6>", function()
      -- TODO: this is not working properly for infinty loops, ctrl+c is not cacelling loop.
      -- works if tmux is installed

      --save file
      vim.cmd "w"

      local tmux_window_name = "python_code_output"
      local tmux_command = "tmux-window-with-command " .. tmux_window_name .. ' "echo "";'

      local current_venv = venv_selctor_python.get_current_venv()
      local python_path
      if current_venv ~= nil then
        local venv_path = current_venv.path
        local venv_activation_path = venv_path .. "/bin/activate"
        tmux_command = tmux_command .. "source " .. venv_activation_path .. ';python %"'
      else
        python_path = vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
        if not python_path then
          vim.notify(
            "Error: No python path found, Install it.",
            vim.log.levels.ERROR,
            { title = "Failed to run python program" }
          )
          return
        end
        tmux_command = tmux_command .. '"' .. python_path .. ' %"'
      end

      vim.cmd("silent !" .. tmux_command)
    end, {
      silent = true,
    })

    vim.keymap.set("n", "<F9>", function()
      --save file
      vim.cmd "w"

      local current_venv = venv_selctor_python.get_current_venv()
      local python_path
      if current_venv ~= nil then
        python_path = venv_selctor_python.make_python_path(current_venv.path)
      else
        python_path = vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
      end
      if not python_path then
        vim.notify(
          "Error: No python path found, Install it.",
          vim.log.levels.ERROR,
          { title = "Failed to run python program" }
        )
        return
      end

      vim.cmd("exec '!" .. python_path .. "' shellescape(@%, 1)")
    end, {
      silent = true,
    })

    vim.keymap.set("n", "<F8>", function()
      -- get mimimal pickup options
      venv_selctor_python.pick_venv()
    end, {
      silent = true,
    })

    vim.keymap.set("n", "<F7>", function()
      -- get all pickup options
      venv_selctor_python.pick_from_all_venvs()
    end, {
      silent = true,
    })

    vim.keymap.set("n", "<F10>", function()
      -- try to source vevn present inside folder
      venv_selctor_python.try_set_in_folder_venv(true)
    end, {
      silent = true,
    })
  end,
})
