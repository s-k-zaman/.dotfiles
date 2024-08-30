local PluginUtils = require("utils.plugins")

return {
    {
        "NvChad/nvim-colorizer.lua",
        lazy = false,
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
            -- execute colorizer as soon as possible
            vim.defer_fn(function()
                require("colorizer").attach_to_buffer(0)
            end, 0)
        end,
    },
}
