return {
    "b0o/incline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
        local COLORS = {
            active_bg = "#1e0a3c",
            active_fg = "#e0def4",
            inactive_bg = "#12061e",
            inactive_fg = "#6e6a86",
            modified = "#e0af68",
            readonly = "#f7768e",
        }

        local function set_hl()
            vim.api.nvim_set_hl(0, "InclineNormal", { bg = COLORS.active_bg, fg = COLORS.active_fg, bold = true })
            vim.api.nvim_set_hl(0, "InclineNormalNC", { bg = COLORS.inactive_bg, fg = COLORS.inactive_fg })
        end

        local _path_cache = {}
        local _git_cache = {}

        local function git_root(dir)
            if _git_cache[dir] ~= nil then
                return _git_cache[dir]
            end
            local git_dir = vim.fn.finddir(".git", dir .. ";")
            local root = git_dir ~= "" and vim.fn.fnamemodify(git_dir, ":h") or false
            _git_cache[dir] = root
            return root
        end

        local MAX_PATH = 45
        local function truncate(path)
            if #path <= MAX_PATH then
                return path
            end
            local fname = vim.fn.fnamemodify(path, ":t")
            local first_dir = path:match("^([^/]+)/")
            if first_dir then
                local candidate = first_dir .. "/…/" .. fname
                if #candidate <= MAX_PATH then
                    return candidate
                end
            end
            return "…/" .. fname
        end

        local function resolve_path(bufnr)
            if _path_cache[bufnr] then
                return _path_cache[bufnr]
            end
            local full = vim.api.nvim_buf_get_name(bufnr)
            if full == "" then
                _path_cache[bufnr] = "[No Name]"
                return "[No Name]"
            end
            local rel
            local cwd = vim.fn.getcwd()
            if vim.startswith(full, cwd .. "/") then
                rel = full:sub(#cwd + 2)
            end
            if not rel then
                for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                    if client.root_dir and vim.startswith(full, client.root_dir .. "/") then
                        rel = full:sub(#client.root_dir + 2)
                        break
                    end
                end
            end
            if not rel then
                local dir = vim.fn.fnamemodify(full, ":h")
                local gr = git_root(dir)
                if gr and vim.startswith(full, gr .. "/") then
                    rel = full:sub(#gr + 2)
                end
            end
            if not rel then
                local home = vim.fn.expand("~")
                if vim.startswith(full, home) then
                    rel = "~" .. full:sub(#home + 1)
                end
            end
            rel = truncate(rel or full)
            _path_cache[bufnr] = rel
            return rel
        end

        local cache_grp = vim.api.nvim_create_augroup("zaman_incline_path_cache", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost", "BufWritePost" }, {
            group = cache_grp,
            callback = function(ev)
                _path_cache[ev.buf] = nil
            end,
        })
        vim.api.nvim_create_autocmd("DirChanged", {
            group = cache_grp,
            callback = function()
                _path_cache = {}
                _git_cache = {}
            end,
        })

        require("incline").setup({
            window = { margin = { vertical = 0, horizontal = 1 } },
            hide = { cursorline = "smart" },
            render = function(props)
                local path = resolve_path(props.buf)
                local fname = vim.fn.fnamemodify(path, ":t")
                local icon, icon_color = require("nvim-web-devicons").get_icon_color(fname)
                local parts = {}
                if icon then
                    table.insert(parts, { icon .. " ", guifg = icon_color })
                end
                table.insert(parts, { path })
                if vim.bo[props.buf].modified then
                    table.insert(parts, { "  ", guifg = COLORS.modified })
                end
                if vim.bo[props.buf].readonly then
                    table.insert(parts, { "  ", guifg = COLORS.readonly })
                end

                return parts
            end,
        })

        set_hl()
        vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = set_hl })
    end,
}
