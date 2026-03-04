return {
    -- only attach in prose filetypes; code comment noise is too high
    filetypes = { "markdown", "text", "gitcommit" },
    settings = {
        ["harper-ls"] = {
            linters = {
                SentenceCapitalization = false,
                SpellCheck = false,
            },
        },
    },
}
