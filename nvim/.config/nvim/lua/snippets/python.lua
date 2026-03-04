local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
    s("main", {
        t({ 'if __name__ == "__main__":', "    " }),
        i(1, "main()"),
    }),

    s("cl", fmt([[
class {}:
    def __init__(self{}):
        {}
]], { i(1, "ClassName"), i(2, ""), i(3, "pass") })),

    s("dc", fmt([[
from dataclasses import dataclass

@dataclass
class {}:
    {}: {}
]], { i(1, "ClassName"), i(2, "field"), i(3, "type") })),

    s("def", fmt([[
def {}({}):
    {}
]], { i(1, "func_name"), i(2, ""), i(3, "pass") })),

    s("adef", fmt([[
async def {}({}):
    {}
]], { i(1, "func_name"), i(2, ""), i(3, "pass") })),

    s("try", fmt([[
try:
    {}
except {} as e:
    {}
]], { i(1, "pass"), i(2, "Exception"), i(3, "raise") })),

    s("deft", fmt([[
def {}({}) -> {}:
    {}
]], { i(1, "func_name"), i(2, ""), i(3, "None"), i(4, "pass") })),

    s("lc", fmt("[ {} for {} in {} ]", { i(1, "expr"), i(2, "x"), i(3, "iterable") })),

    -- k and v mirror into the for clause
    s("dc2", fmt("{{ {}: {} for {}, {} in {}.items() }}", { i(1, "k"), i(2, "v"), rep(1), rep(2), i(3, "dict") })),

    s("pp", fmt('print(f"{} = {{{}}}")', { i(1, "var"), rep(1) })),
    s("bp", t("breakpoint()")),
    s("all", fmt('__all__ = ["{}"]', { i(1, "") })),

    s("with", fmt([[
with open("{}", "{}") as {}:
    {}
]], { i(1, "file.txt"), i(2, "r"), i(3, "f"), i(4, "data = f.read()") })),
}
