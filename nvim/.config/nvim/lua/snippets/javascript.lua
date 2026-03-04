local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
    s("cl", fmt("console.log({});", { i(1, "") })),
    s("clv", fmt('console.log("{}", {});', { i(1, "label"), rep(1) })),
    s("af", fmt("const {} = ({}) => {};", { i(1, "name"), i(2, ""), i(3, "{}") })),
    s("aaf", fmt("const {} = async ({}) => {};", { i(1, "name"), i(2, ""), i(3, "{}") })),

    s("uef", fmt([[
useEffect(() => {{
    {}
}}, [{}]);
]], { i(1, ""), i(2, "") })),

    -- setter is auto-capitalized: state → setState
    s("ust", {
        t("const ["),
        i(1, "state"),
        t(", set"),
        f(function(args)
            local name = args[1][1]
            if name and #name > 0 then
                return name:sub(1, 1):upper() .. name:sub(2)
            end
            return ""
        end, { 1 }),
        t("] = useState("),
        i(2, "null"),
        t(");"),
    }),

    s("urf", fmt("const {} = useRef({});", { i(1, "ref"), i(2, "null") })),

    s("umm", fmt([[
const {} = useMemo(() => {{
    return {};
}}, [{}]);
]], { i(1, "value"), i(2, ""), i(3, "") })),

    s("ucb", fmt([[
const {} = useCallback(({}) => {{
    {}
}}, [{}]);
]], { i(1, "fn"), i(2, ""), i(3, ""), i(4, "") })),

    s("rfce", fmt([[
import React from "react";

function {}({}) {{
    return (
        <div>
            {}
        </div>
    );
}}

export default {};
]], { i(1, "Component"), i(2, ""), i(3, ""), rep(1) })),

    s("rafce", fmt([[
import React from "react";

const {} = ({}) => {{
    return (
        <div>
            {}
        </div>
    );
}};

export default {};
]], { i(1, "Component"), i(2, ""), i(3, ""), rep(1) })),

    s("imp", fmt('import {} from "{}";', { i(1, "module"), i(2, "path") })),
    s("imn", fmt('import {{ {} }} from "{}";', { i(1, "name"), i(2, "path") })),

    s("fetch", fmt([[
fetch("{}")
    .then((res) => res.json())
    .then((data) => {{
        {}
    }})
    .catch((err) => console.error(err));
]], { i(1, "url"), i(2, "console.log(data)") })),

    s("afetch", fmt([[
const {} = async () => {{
    try {{
        const res = await fetch("{}");
        const data = await res.json();
        {}
    }} catch (err) {{
        console.error(err);
    }}
}};
]], { i(1, "fetchData"), i(2, "url"), i(3, "return data;") })),

    s("tryc", fmt([[
try {{
    {}
}} catch (err) {{
    console.error(err);
}}
]], { i(1, "") })),

    s("fe", fmt("{}.forEach(({}) => {{\n    {}\n}});", { i(1, "array"), i(2, "item"), i(3, "") })),
    s("map", fmt("{}.map(({}) => {})", { i(1, "array"), i(2, "item"), i(3, "item") })),
    s("fil", fmt("{}.filter(({}) => {})", { i(1, "array"), i(2, "item"), i(3, "true") })),
    s("ter", fmt("{} ? {} : {}", { i(1, "condition"), i(2, "true"), i(3, "false") })),
}
