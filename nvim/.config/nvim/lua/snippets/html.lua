local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    -- ! = HTML5 boilerplate (mirrors Emmet)
    s("!", {
        t({
            "<!DOCTYPE html>",
            '<html lang="en">',
            "<head>",
            '    <meta charset="UTF-8" />',
            '    <meta name="viewport" content="width=device-width, initial-scale=1.0" />',
            "    <title>",
        }),
        i(1, "Document"),
        t({
            "</title>",
            "</head>",
            "<body>",
            "    ",
        }),
        i(2, ""),
        t({
            "",
            "</body>",
            "</html>",
        }),
    }),

    s("divc", {
        t('<div class="'),
        i(1, "class"),
        t({ '">', "    " }),
        i(2, ""),
        t({ "", "</div>" }),
    }),

    s("link", {
        t('<link rel="stylesheet" href="'),
        i(1, "style.css"),
        t('" />'),
    }),

    s("script", {
        t('<script src="'),
        i(1, "main.js"),
        t('"></script>'),
    }),

    s("a", {
        t('<a href="'),
        i(1, "#"),
        t('">'),
        i(2, "text"),
        t("</a>"),
    }),

    s("img", {
        t('<img src="'),
        i(1, "image.png"),
        t('" alt="'),
        i(2, "description"),
        t('" />'),
    }),

    s("input", {
        t('<input type="'),
        i(1, "text"),
        t('" name="'),
        i(2, "name"),
        t('" placeholder="'),
        i(3, "placeholder"),
        t('" />'),
    }),
}
