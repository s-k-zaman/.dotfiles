local PluginUtils = require("utils.plugins")

return {
    {
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPost",
        config = function()
            local enable_tailwind = true
            if PluginUtils.has("tailwind-tools") and USE_LSPKIND then
                enable_tailwind = false
            end
            require("colorizer").setup({
                user_default_options = {
                    tailwind = enable_tailwind,
                },
            })
            -- Attach to the buffer that triggered our load (BufReadPost has already fired for it)
            vim.schedule(function()
                if vim.bo.buftype == "" then
                    require("colorizer").attach_to_buffer(0)
                end
            end)
        end,
    },
    {
        "amadeus/vim-convert-color-to",
        event = "VeryLazy",
    },
}
