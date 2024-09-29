return {
    tailwindCSS = {
        experimental = {
            classRegex = {
                {
                    "classNames\\(([^)]*)\\)",
                    "[\"'`]([^\"'`]*)[\"'`]",
                },
                { "(?:twMerge|twJoin)\\(([^;]*)[\\);]", "[`'\"`]([^'\"`;]*)[`'\"`]" }, --tailwind merge
                { "tv\\(([^)]*)\\)", "{?\\s?[\\w].*:\\s*?[\"'`]([^\"'`]*).*?,?\\s?}?" }, --tailwind varint
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" }, --cva
            },
        },
    },
}
