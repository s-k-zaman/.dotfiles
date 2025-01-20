return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
        config = function()
            vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreview<cr>", { desc = "markdown preview: start" })
            vim.keymap.set("n", "<leader>mx", "<cmd>MarkdownPreviewStop<cr>", { desc = "markdown preview: stop" })
            vim.keymap.set("n", "<leader>mtp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "markdown preview: toggle" })
        end,
    },
    {
        "ellisonleao/glow.nvim",
        cmd = "Glow",
        ft = { "markdown" },
        config = function()
            require("glow").setup()
            vim.keymap.set("n", "<leader>mp", "<cmd>Glow<cr>", { desc = "markdown preview[glow]" })
        end,
    },
}
