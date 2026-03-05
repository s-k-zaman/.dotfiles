return {
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        ft = "python", -- Load when opening Python files
        opts = { -- this can be an empty lua table - just showing below for clarity.
            search = {}, -- if you add your own searches, they go here.
            options = { -- if you add plugin options, they go here.
                -- debug = true,
                enable_default_searches = true, -- switches all default searches on/off
                -- notify_user_on_venv_activation = true, -- notifies user on activation of the virtual env
                -- FIX: auto for picker is not working[telescope is not working]
                picker = "snacks", -- the picker to use. Valid options are "telescope", "fzf-lua", "snacks", "native", "mini-pick" or "auto"
                on_venv_activate_callback = function()
                    vim.cmd("LspRestart")
                end,
            },
        },
        keys = {
            { "<F4>", "<cmd>VenvSelect<cr>" }, -- Open picker on keymap
        },
    },
}
