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
            vim.api.nvim_set_hl(0, "InclineNormal", {
                bg = COLORS.active_bg,
                fg = COLORS.active_fg,
                bold = true,
            })
            vim.api.nvim_set_hl(0, "InclineNormalNC", {
                bg = COLORS.inactive_bg,
                fg = COLORS.inactive_fg,
            })
        end

        -- ── Path resolution (cached per buffer, no shell) ─────────────────────
        local _path_cache = {} -- { [bufnr] = "display/path" }
        local _git_cache = {} -- { [dir]   = "git-root" | false }

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

        -- Render parts for top (incline) and bottom (plain float) renderers
        -- To add/remove display elements, only change this function.
        local function get_render_parts(bufnr)
            local path = resolve_path(bufnr)
            local fname = vim.fn.fnamemodify(path, ":t")
            local icon, icon_color = require("nvim-web-devicons").get_icon_color(fname)
            local parts = {}
            if icon then
                table.insert(parts, { text = icon .. " ", hl = icon_color })
            end
            table.insert(parts, { text = path })
            if vim.bo[bufnr].modified then
                table.insert(parts, { text = "  ", hl = COLORS.modified })
            end
            if vim.bo[bufnr].readonly then
                table.insert(parts, { text = "  ", hl = COLORS.readonly })
            end
            return parts
        end

        -- ── Renderer adapters ─────────────────────────────────────────────────
        -- Adapter A: incline's render format — list of { "text", guifg = color? }
        local function to_incline_parts(parts)
            return vim.tbl_map(function(p)
                local item = { p.text }
                if p.hl then
                    item.guifg = p.hl
                end
                return item
            end, parts)
        end

        -- Adapter B: plain buffer + extmark highlights (for the bottom float).
        -- Uses byte positions (correct for nvim_buf_set_extmark).
        -- Caches named hl groups for each unique hex color so we don't spam nvim_set_hl.
        local _ns = vim.api.nvim_create_namespace("zaman_incline_bottom_hl")
        local _color_hls = {} -- { ["#rrggbb"] = "InclineColor_rrggbb" }

        local function ensure_color_hl(hex)
            if not _color_hls[hex] then
                local name = "InclineColor_" .. hex:gsub("#", "")
                vim.api.nvim_set_hl(0, name, { fg = hex })
                _color_hls[hex] = name
            end
            return _color_hls[hex]
        end

        local PAD = " "

        local function apply_parts_to_buf(sbuf, parts)
            local line = PAD
            local segs = {} -- { col_start_byte, col_end_byte, hex_color }

            for _, p in ipairs(parts) do
                local s = #line -- byte offset
                line = line .. p.text
                if p.hl then
                    table.insert(segs, { s, #line, p.hl })
                end
            end
            line = line .. PAD

            vim.api.nvim_buf_set_lines(sbuf, 0, -1, false, { line })
            vim.api.nvim_buf_clear_namespace(sbuf, _ns, 0, -1)

            for _, seg in ipairs(segs) do
                vim.api.nvim_buf_set_extmark(sbuf, _ns, 0, seg[1], {
                    end_col = seg[2],
                    hl_group = ensure_color_hl(seg[3]),
                    priority = 200,
                })
            end

            return line -- caller uses this for display-width measurement
        end

        -- Invalidate color hl cache on ColorScheme so themes can't clobber our groups.
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                _color_hls = {}
            end,
        })

        -- ── Bottom float ──────────────────────────────────────────────────────
        local _bottom = {} -- { [winid] = { float=winid, buf=bufnr } }
        local _prev_state = {} -- { [winid] = bool } last known at-top state

        local function show_bottom(win)
            if not vim.api.nvim_win_is_valid(win) then
                return
            end
            local bufnr = vim.api.nvim_win_get_buf(win)
            local parts = get_render_parts(bufnr)
            local win_w = vim.api.nvim_win_get_width(win)
            local win_h = vim.api.nvim_win_get_height(win)

            local e = _bottom[win]
            if e and vim.api.nvim_win_is_valid(e.float) then
                local line = apply_parts_to_buf(e.buf, parts)
                local float_w = math.min(vim.fn.strdisplaywidth(line), math.floor(win_w * 0.7))
                vim.api.nvim_win_set_config(e.float, {
                    relative = "win",
                    win = win,
                    row = win_h - 1,
                    col = win_w - float_w - 1,
                    width = float_w,
                    height = 1,
                })
            else
                local sbuf = vim.api.nvim_create_buf(false, true)
                local line = apply_parts_to_buf(sbuf, parts)
                local float_w = math.min(vim.fn.strdisplaywidth(line), math.floor(win_w * 0.7))
                local fwin = vim.api.nvim_open_win(sbuf, false, {
                    relative = "win",
                    win = win,
                    row = win_h - 1,
                    col = win_w - float_w - 1,
                    width = float_w,
                    height = 1,
                    style = "minimal",
                    focusable = false,
                    zindex = 44,
                })
                vim.wo[fwin].winhl = "Normal:InclineNormal"
                _bottom[win] = { float = fwin, buf = sbuf }
            end
        end

        local function hide_bottom(win)
            local e = _bottom[win]
            if not e then
                return
            end
            if vim.api.nvim_win_is_valid(e.float) then
                vim.api.nvim_win_close(e.float, true)
            end
            if vim.api.nvim_buf_is_valid(e.buf) then
                vim.api.nvim_buf_delete(e.buf, { force = true })
            end
            _bottom[win] = nil
        end

        local function check_win(win)
            if not vim.api.nvim_win_is_valid(win) then
                hide_bottom(win)
                _prev_state[win] = nil
                return
            end
            local ok, cursor = pcall(vim.api.nvim_win_get_cursor, win)
            if not ok then
                return
            end
            local at_top = cursor[1] == vim.fn.line("w0", win)

            if _prev_state[win] == at_top then
                if at_top then
                    show_bottom(win)
                end
                return
            end

            _prev_state[win] = at_top
            if at_top then
                show_bottom(win)
            else
                hide_bottom(win)
            end
        end

        local bot_grp = vim.api.nvim_create_augroup("zaman_incline_bottom", { clear = true })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = bot_grp,
            callback = function()
                local win = vim.api.nvim_get_current_win()
                local ok, cursor = pcall(vim.api.nvim_win_get_cursor, win)
                if not ok then
                    return
                end
                local at_top = cursor[1] == vim.fn.line("w0", win)
                if _prev_state[win] ~= at_top then
                    vim.schedule(function()
                        check_win(win)
                    end)
                end
            end,
        })
        vim.api.nvim_create_autocmd("WinScrolled", {
            group = bot_grp,
            callback = function()
                vim.schedule(function()
                    check_win(vim.api.nvim_get_current_win())
                end)
            end,
        })
        vim.api.nvim_create_autocmd("WinResized", {
            group = bot_grp,
            callback = function()
                vim.schedule(function()
                    local win = vim.api.nvim_get_current_win()
                    if _prev_state[win] then
                        show_bottom(win)
                    end
                end)
            end,
        })
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWritePost" }, {
            group = bot_grp,
            callback = function()
                local win = vim.api.nvim_get_current_win()
                if _prev_state[win] then
                    vim.schedule(function()
                        show_bottom(win)
                    end)
                end
            end,
        })
        vim.api.nvim_create_autocmd("WinClosed", {
            group = bot_grp,
            callback = function(ev)
                local win = tonumber(ev.match)
                if win then
                    hide_bottom(win)
                    _prev_state[win] = nil
                end
            end,
        })

        -- ── incline setup ─────────────────────────────────────────────────────
        require("incline").setup({
            window = { margin = { vertical = 0, horizontal = 1 } },
            hide = { cursorline = true },
            render = function(props)
                return to_incline_parts(get_render_parts(props.buf))
            end,
        })

        set_hl()
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_hl,
        })
    end,
}
