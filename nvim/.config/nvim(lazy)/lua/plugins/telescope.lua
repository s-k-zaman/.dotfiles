local Util = require("lazyvim.util")

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  opts = {
    defaults = {
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
        },
      },
    },
  },
  keys = {
    -- find
    {
      "<leader>ff",
      "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
      desc = "Find All Files",
    },
    -- grep_string
    { "<leader>fg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
    { "<leader>fG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
    { "<leader>fw", Util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
    { "<leader>fW", Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
    { "<leader>fw", Util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
    { "<leader>fW", Util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
    {
      "<leader>/",
      function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end,
      desc = "Find inside buffer",
    },
    {
      "<leader>fs",
      function()
        require("telescope.builtin").lsp_document_symbols(require("telescope.themes").get_dropdown({
          symbols = require("lazyvim.config").get_kind_filter(),
        }))
      end,
      desc = "Goto Symbol(buf)",
    },
    {
      "<leader>fS",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols(require("telescope.themes").get_dropdown({
          symbols = require("lazyvim.config").get_kind_filter(),
        }))
      end,
      desc = "Goto Symbol (Workspace)",
    },
  },
}
