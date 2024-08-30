return {
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
            -- "mfussenegger/nvim-dap-python"
        },
        -- branch = "regexp", -- This is the regexp branch, use this for the new version
        lazy = false,
        config = function()
            local opts = {
                -- Your options go here
                stay_on_this_version = true,
                -- auto_refresh = false,
                search_venv_managers = false,
                name = {
                    "venv",
                    ".venv",
                    -- "env",
                    -- ".env",
                },
                parents = 1,
            }
            if require("utils.plugins").has("nvim-dap-python") then
                opts.dap_enabled = true
            end
            require("venv-selector").setup(opts)

            local map = require("utils.keymapper").keymap
            -- map("n", "<leader>cv", "<cmd>:VenvSelect<cr>", {
            --     desc = "Select VirtualEnv",
            -- })
        end,
    },
}
