return {
    -- {
    --     "vhyrro/luarocks.nvim",
    --     priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    --     config = true,
    -- },
    { "folke/neodev.nvim", opts = {} },
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = false,
        config = true,
    },
    { "echasnovski/mini.icons", version = "*" },
    -- {
    --     "venv-selector",
    --     dir = "/home/zaman/projects/luaPlugins/venv-selector.nvim",
    --     lazy = false,
    --     config = function()
    --         require("venv-selector").setup()
    --     end,
    -- },
}
