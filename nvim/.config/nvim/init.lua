-- INFO: although its basic
-- c-i<same key-signal as Tab> is behaving strange, no mapping is Working.
-- ANS: it is associated with jumplist just like-> c-o

-- COLORSCHEME = "nordfox"
-- COLORSCHEME = "nightfox"
-- COLORSCHEME = "onedark"
-- COLORSCHEME = "kanagawa-wave" -- options: -dragon, -wave, -lotus
COLORSCHEME = "rose-pine"
TRANSPARENT = true
Disable_Lsp_Server_Formatting = true
USE_LSPKIND = true -- vs-Code like autocompletion
USE_LAZYGIT = true -- vs-Code like autocompletion
USE_LSP_SAGA = vim.fn.has("nvim-0.13") == 0 -- here ==0 implies less than specified version
CONFIG_TAILWIND_IN_LSPCONFIG = true
require("config")
