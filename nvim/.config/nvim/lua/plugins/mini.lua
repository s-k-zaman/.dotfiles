return {
    {
        "nvim-mini/mini.nvim",
        version = false,
        lazy = false,
        config = function()
            -- Here call what plugins you need in setup
            -- IMPORTANT: check if not used, before adding setup here
            if USE_MINI_TEXT_OBJECTS then
                local mini_ai = require("mini.ai")
                mini_ai.setup({
                    custom_textobjects = {
                        s = { "%[%[().-()%]%]" },
                        f = mini_ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
                    },
                })
            end
        end,
    },
}
