return {
    ensure_installed = {"lua-language-server"}, -- not an option from mason.nvim

    ui = {
        icons = {
            package_pending = " ",
            package_installed = "󰄳 ",
            package_uninstalled = " 󰚌"
        }
    },

    max_concurrent_installers = 10
}
