local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s("lf", fmt("local {} = function({})\n    {}\nend", { i(1, "name"), i(2, ""), i(3, "") })),
    s("fn", fmt("function {}({})\n    {}\nend", { i(1, "name"), i(2, ""), i(3, "") })),
    s("lv", fmt("local {} = {}", { i(1, "name"), i(2, "nil") })),
    s("req", fmt('local {} = require("{}")', { i(1, "module"), i(2, "") })),
    s("if", fmt("if {} then\n    {}\nend", { i(1, "condition"), i(2, "") })),
    s("ife", fmt("if {} then\n    {}\nelse\n    {}\nend", { i(1, "condition"), i(2, ""), i(3, "") })),
    s("fip", fmt("for {}, {} in ipairs({}) do\n    {}\nend", { i(1, "i"), i(2, "v"), i(3, "table"), i(4, "") })),
    s("fpa", fmt("for {}, {} in pairs({}) do\n    {}\nend", { i(1, "k"), i(2, "v"), i(3, "table"), i(4, "") })),
    s("fn2", fmt("for {} = {}, {} do\n    {}\nend", { i(1, "i"), i(2, "1"), i(3, "n"), i(4, "") })),
    s("pc", fmt("local {}, {} = pcall({})", { i(1, "ok"), i(2, "err"), i(3, "fn") })),
    s("map", fmt('vim.keymap.set("{}", "{}", {}, {{ desc = "{}" }})', { i(1, "n"), i(2, "lhs"), i(3, "rhs"), i(4, "description") })),
    s("au", fmt([[
vim.api.nvim_create_autocmd("{}", {{
    pattern = "{}",
    callback = function()
        {}
    end,
}})
]], { i(1, "BufWritePre"), i(2, "*"), i(3, "") })),
    s("pd", fmt('print(vim.inspect({}))', { i(1, "value") })),
}
