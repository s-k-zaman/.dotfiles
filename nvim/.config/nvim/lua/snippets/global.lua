local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function get_date()
    return os.date("%m-%d-%Y")
end

return {
    s("zaman", t("Zaman")),
    s("zaman", t("S-K-Zaman")),
    s("zaman", t("s-k-zaman")),
    s("zaman", t("S. K. Zaman")),
    s("zaman", t("Sk Khairul Zaman")),
    s("skz", t("Sk Khairul Zaman")),
    s("skz", t("S-K-Zaman")),
    s("skz", t("s-k-zaman")),
    
    s("zammail", t("sudo.coder.zaman@gmail.com")),
    s("zamgit", t("https://github.com/s-k-zaman/")),
    s("zamlinkedIn", t("https://www.linkedin.com/in/s-k-zaman/")),
    s("zamportfolio", t("https://s-k-zaman.github.io/")),
    s("zamx", t("https://x.com/s_k_zaman/")),
    s("zamtweet", t("https://x.com/s_k_zaman/")),
}
