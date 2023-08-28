require("zaman.set")
require("mappings.base")
require("plugins") -- plugin
require("plugins.configs.colorscheme") -- use until found a plugin.
require("mappings") -- load other mappings
require("autocmds")

-- other plugins settings, not configuring directly from plugins section.
require("plugins.configs.zenmode")
require("plugins.configs.fugitive") -- should active in git folders.
require("plugins.configs.lualine")
