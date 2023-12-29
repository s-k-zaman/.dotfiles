-- build: runs on install or update.
-- cmd: will lazy load this plugin on this command/acceble through this command other wise inactive.
-- opts: should be a table (will be merged with parent specs), return a table (replaces parent specs) or
--          should change a table. The table will be passed to the config() function.
--           Setting this value will imply config()
-- config: configuration file/do configuration inside a function.
--          config is executed when the plugin loads.
--          To use the default implementation without opts set config to `true`.
-- init: init functions are always executed during startup

return {
	-- here goes all the helper plugins/miscs.
	-- others plugins are in lua/plugins directory...
	{ "nvim-lua/plenary.nvim" },
	{
		"nvim-tree/nvim-web-devicons",
		opts = {},
	},
}
