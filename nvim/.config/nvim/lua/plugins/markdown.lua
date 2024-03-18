return {
    {
        "lukas-reineke/headlines.nvim",
        lazy = false,
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = {},
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
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
