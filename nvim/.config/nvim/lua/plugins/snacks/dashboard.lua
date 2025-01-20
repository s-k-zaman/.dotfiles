local glyphs = require("utils.glyphs")

return {
    preset = {
        header = glyphs.zaman,
    },
    sections = {
        -- pane 1
        { section = "startup", padding = 2 },
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        -- pane 2
        function()
            local in_git = Snacks.git.get_root() ~= nil
            local cmds = {
                {
                    title = "Browse Repo",
                    icon = " ",
                    key = "b",
                    action = function()
                        Snacks.gitbrowse()
                    end,
                },
                {
                    title = "Open Issues",
                    key = "i",
                    action = function()
                        vim.fn.jobstart("gh issue list --web", { detach = true })
                    end,
                    icon = " ",
                    -- section = "terminal",
                    -- cmd = "gh issue list -L 3",
                    -- height = 7,
                },
                {
                    title = "Git Notifications",
                    section = "terminal",
                    cmd = "gh notify -s -a -n5",
                    action = function()
                        vim.ui.open("https://github.com/notifications")
                    end,
                    key = "n",
                    icon = " ",
                    height = 5,
                    enabled = true,
                },
                {
                    icon = " ",
                    title = "Open PRs",
                    section = "terminal",
                    cmd = "gh pr list -L 3",
                    key = "p",
                    action = function()
                        vim.fn.jobstart("gh pr list --web", { detach = true })
                    end,
                    height = 7,
                },
                {
                    icon = " ",
                    title = "Git Status",
                    section = "terminal",
                    cmd = "git --no-pager diff --stat -B -M -C",
                    height = 10,
                },
                {
                    icon = " ",
                    title = "Projects",
                    section = "projects",
                    enabled = not in_git,
                },
                {
                    section = "terminal",
                    cmd = "fortune -s | cowsay",
                    ttl = 5,
                    hl = "header",
                    padding = 1,
                    indent = 8,
                    enabled = not in_git,
                },
            }
            return vim.tbl_map(function(cmd)
                return vim.tbl_extend("force", {
                    pane = 2,
                    enabled = in_git,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 3,
                }, cmd)
            end, cmds)
        end,
    },
}
