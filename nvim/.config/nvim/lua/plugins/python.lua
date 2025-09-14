return {
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
        },
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
                    local lsp_reloaded = false

                    local function reload_lsp()
                        if lsp_reloaded then
                            return
                        end
                        vim.cmd("LspRestart")
                        lsp_reloaded = true
                    end

                    -- Create a unique augroup
                    local group = vim.api.nvim_create_augroup("VenvLspReload", { clear = true })

                    vim.api.nvim_create_autocmd("User", {
                        group = group,
                        pattern = "VenvActivated", -- ← depends on your venv plugin
                        callback = reload_lsp,
                    })
                end,
            },
        },
        keys = {
            { "<F8>", "<cmd>VenvSelect<cr>" }, -- Open picker on keymap
        },
    },
}
