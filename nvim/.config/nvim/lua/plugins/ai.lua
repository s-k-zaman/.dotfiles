local suggestions = {
    accept = "<M-y>",
    next = "<M-n>",
    prev = "<M-p>",
    dismiss = "<M-c>",
}
return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            local opts = {
                suggestion = {
                    auto_trigger = false,
                    keymap = suggestions,
                },
            }
            require("copilot").setup(opts)

            -- keymaps
            vim.keymap.set(
                "n",
                "<leader>ct",
                require("copilot.suggestion").toggle_auto_trigger,
                { desc = "copilot: toggle suggestions" }
            )
        end,
    },
    {
        "NickvanDyke/opencode.nvim",
        lazy = false,
        dependencies = {
            -- Recommended for `ask()` and `select()`.
            -- Required for `toggle()`.
            { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
        },
        config = function()
            vim.g.opencode_opts = {
                -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on `opencode_opts`.
            }

            -- Required for `vim.g.opencode_opts.auto_reload`.
            vim.o.autoread = true

            -- stylua: ignore start
            -- Recommended/example keymaps.
            vim.keymap.set({ "n", "x" }, "<leader>at", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask about this" })
            vim.keymap.set({ "n", "x" }, "<leader>as", function() require("opencode").select() end, { desc = "Select prompt" })
            vim.keymap.set({ "n", "x" }, "<leader>a+", function() require("opencode").prompt("@this") end, { desc = "Add this" })
            vim.keymap.set("n", "<leader>aa", function() require("opencode").toggle() end, { desc = "Toggle embedded" })
            vim.keymap.set("n", "<leader>ac", function() require("opencode").command() end, { desc = "Select command" })
            vim.keymap.set("n", "<leader>an", function() require("opencode").command("session_new") end, { desc = "New session" })
            vim.keymap.set("n", "<leader>ai", function() require("opencode").command("session_interrupt") end, { desc = "Interrupt session" })
            vim.keymap.set("n", "<leader>am", function() require("opencode").command("agent_cycle") end, { desc = "Cycle selected agent" })
            vim.keymap.set("n", "<S-C-u>",    function() require("opencode").command("messages_half_page_up") end, { desc = "Messages half page up" })
            vim.keymap.set("n", "<S-C-d>",    function() require("opencode").command("messages_half_page_down") end, { desc = "Messages half page down" })
            -- stylua: ignore end
        end,
    },
    {
        "yetone/avante.nvim",
        enabled = false,
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        -- ⚠️ must add this setting! ! !
        build = vim.fn.has("win32") ~= 0
                and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            or "make",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            -- add any opts here
            -- this file can contain specific instructions for your project
            instructions_file = "avante.md",
            windows = {
                ---@type "right" | "left" | "top" | "bottom"
                position = "right",
                width = 37,
            },
            behaviour = {
                auto_suggestions = false, -- Experimental stage
            },
            mappings = {
                suggestions = suggestions,
            },
            -- for example
            -- provider = "gemini",
            provider = "openrouter",
            providers = {
                gemini = {
                    -- model = "gemini-2.5-pro-exp-03-25",
                    model = "gemini-2.5-pro",
                },
                openrouter = {
                    __inherited_from = "openai",
                    endpoint = "https://openrouter.ai/api/v1",
                    api_key_name = "AVANTE_OPENROUTER_API_KEY", -- Name of the environment variable for your API key
                    model = "google/gemini-2.0-flash-exp:free",
                },
                -- openai = {
                --     endpoint = "http://3.210.15.125:4000/",
                --     -- model = "claude-3-7-sonnet",
                --     model = "claude-sonnet-4",
                -- },
                -- claude = {
                --     endpoint = "https://api.anthropic.com",
                --     model = "claude-sonnet-4-20250514",
                --     timeout = 30000, -- Timeout in milliseconds
                --     extra_request_body = {
                --         temperature = 0.75,
                --         max_tokens = 20480,
                --     },
                -- },
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "echasnovski/mini.pick", -- for file_selector provider mini.pick
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
            "ibhagwan/fzf-lua", -- for file_selector provider fzf
            "stevearc/dressing.nvim", -- for input provider dressing
            "folke/snacks.nvim", -- for input provider snacks
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
}
