local augroup = require("utils").augroup
local venv_selctor_python = require("modules.venv_selector_python")

-- vim.api.nvim_create_autocmd("BufWinEnter", {
--     group = augroup("python_venv"),
--     pattern = "*.py",
--     callback = function()
--         local current_venv = require("venv-selector").venv()
--         if current_venv == nil then
--             require("venv-selector").retrieve_from_cache()
--         end
--     end,
-- })

-- vim.api.nvim_create_autocmd("VimEnter", {
--     desc = "Auto select virtualenv Nvim open",
--     pattern = "*",
--     callback = function()
--         print('hii')
--         local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
--         if venv ~= "" then
--             require("venv-selector").retrieve_from_cache()
--         end
--     end,
--     -- once = true,
-- })

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = augroup("python_keymaps"),
    pattern = "*.py",
    callback = function()
        --running program using F5
        vim.keymap.set("n", "<F5>", function()
            -- TODO: find best way to handle terminal output
            -- see `Run your own code on venv activation (on_venv_activate_callback)`
            -- on: https://github.com/linux-cultist/venv-selector.nvim?tab=readme-ov-file
            --save file
            vim.cmd("w")

            -- local current_venv = venv_selctor_python.get_current_venv()
            local current_venv = require("venv-selector").venv()
            local python_path
            if current_venv ~= nil then
                python_path = venv_selctor_python.make_python_path(current_venv)
            else
                python_path = vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
            end
            if not python_path then
                vim.notify(
                    "Error: No python path found, Install it.",
                    vim.log.levels.ERROR,
                    { title = "Failed to run python program" }
                )
                return
            end

            vim.cmd('exec \'!printf "\\n\\n";' .. python_path .. "' shellescape(@%, 1)")
        end, {
            silent = true,
        })

        vim.keymap.set("n", "<F6>", function()
            -- FIX: this is not working properly for infinity loops, ctrl+c is not cancelling loop.
            -- works if tmux is installed
            -- TODO: find best way to handle tmux output

            --save file
            vim.cmd("w")

            local tmux_window_name = "python_code_output"
            local tmux_command = "tmux-window-with-command " .. tmux_window_name .. ' "echo "OUTPUT:";'

            -- local current_venv = venv_selctor_python.get_current_venv()
            local current_venv = require("venv-selector").venv()
            local python_path
            if current_venv ~= nil then
                -- local venv_path = current_venv.path
                local venv_path = current_venv
                local venv_activation_path = venv_path .. "/bin/activate"
                tmux_command = tmux_command .. "source " .. venv_activation_path .. ';python %"'
            else
                python_path = vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
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
    end,

    -- running program: in tmux new-window
    -- TODO: remove on fixing F6 output shortcut
    vim.keymap.set("n", "<F10>", function()
        --save file
        vim.cmd("w")
        -- then run with available sources
        -- local current_venv = venv_selctor_python.get_current_venv()
        local current_venv = require("venv-selector").venv()
        if current_venv ~= nil then
            -- source virtual environment then run
            -- local venv_path = current_venv.path
            -- local venv_name = current_venv.name
            -- local venv_activation_path = venv_path .. "/bin/activate"
            local venv_activation_path = current_venv .. "/bin/activate"
            vim.cmd(
                'silent !tmux neww bash -c "source '
                    .. venv_activation_path
                    .. ";echo 'in virtual env ->"
                    -- .. venv_name
                    .. current_venv
                    .. "';echo '----------- running program --------------';"
                    .. "python %;echo '';echo 'Done.';echo 'Ctrl+c to exit'"
                    .. ';while [ : ]; do sleep 1; done"'
            )
        else
            local python_path = vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
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
    }),
})
