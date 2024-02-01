return {
    { "folke/neodev.nvim", opts = {} },
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    {
        "/nvim-tree/nvim-web-devicons",
        lazy = false,
        config = true,
    },
    -- {
    --     "venv-selector",
    --     dir = "/home/zaman/projects/luaPlugins/venv-selector.nvim",
    --     lazy = false,
    --     config = function()
    --         require("venv-selector").setup()
    --     end,
    -- },
}
