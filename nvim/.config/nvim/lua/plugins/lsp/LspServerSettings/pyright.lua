return {
    python = {
        analysis = {
            autoSearchPaths = true,
            typeCheckingMode = "off", -- "off", "basic" and "strict"
            diagnosticMode = "workspace",
            inlayHints = {
                variableTypes = true,
                functionReturnTypes = true,
            },
        },
    },
}
