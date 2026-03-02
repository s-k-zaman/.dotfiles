COLORSCHEME = "rose-pine"
TRANSPARENT = true
Disable_Lsp_Server_Formatting = true
USE_LSPKIND = true -- vs-Code like autocompletion
USE_LAZYGIT = true -- vs-Code like autocompletion
USE_LSP_SAGA = vim.fn.has("nvim-0.13") == 0 -- here ==0 implies less than specified version
CONFIG_TAILWIND_IN_LSPCONFIG = true
USE_MINI_TEXT_OBJECTS = true

-- editor behaviour
AUTO_RELOAD = true -- reload buffer when file changes externally (autoread + checktime)
RESTORE_CURSOR = true -- restore cursor to last position when reopening a file
SPELL_CHECK = true -- enable spell checking
SYNC_CLIPBOARD = true -- sync system clipboard with unnamed register
INDENT_SIZE = 4 -- spaces per indent level (tabstop / softtabstop / shiftwidth)
COLOR_COLUMN = 80 -- ruler column (set to 0 to disable)
SCROLL_OFF = 8 -- lines of context above/below cursor (0 to disable)
CENTER_SCROLL = true -- center cursor after <C-d>/<C-u> half-page jumps

require("core")
