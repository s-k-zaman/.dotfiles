return {
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
            -- "mfussenegger/nvim-dap-python"
        },
        config = function()
            local opts = {
                -- Your options go here
                -- auto_refresh = false
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
