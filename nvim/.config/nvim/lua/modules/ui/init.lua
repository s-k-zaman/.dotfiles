local M = {}

-- Cache: { [venv_path] = { mtime = N, full_str = "rendered" } }
local _cache = {}

local function get_mtime(path)
    local stat = (vim.uv or vim.loop).fs_stat(path)
    return stat and stat.mtime.sec or 0
end

M.python_venv_selector = function()
    -- Short-circuit for non-Python buffers
    if vim.bo.filetype ~= "python" then
        return ""
    end

    local ok, vs = pcall(require, "venv-selector")
    if not ok then
        return ""
    end

    local venv_path = vs.venv()
    if not venv_path then
        return ""
    end

    local cfg_path = venv_path .. "/pyvenv.cfg"
    local mtime = get_mtime(cfg_path)

    -- Return cached result if venv hasn't changed on disk
    local cached = _cache[venv_path]
    if cached and cached.mtime == mtime then
        return cached.full_str
    end

    -- ── Extract venv folder name (last path component) ───────────────
    local folder_name = venv_path:match("/([^/]+)$") or "venv"

    -- ── Parse pyvenv.cfg: get `prompt` key ───────────────────────────
    local prompt_name = nil
    local f = io.open(cfg_path, "r")
    if f then
        for line in f:lines() do
            local v = line:match("^prompt%s*=%s*(.-)%s*$")
            if v and v ~= "" then
                prompt_name = v
                break
            end
        end
        f:close()
    end

    -- ── Python version from venv binary (one io.popen per unique path) ──
    -- This runs once per venv and is then cached alongside mtime.
    local py_ver = ""
    local py_bin = venv_path .. "/bin/python"
    local py_stat = (vim.uv or vim.loop).fs_stat(py_bin)
    if py_stat then
        local fh = io.popen(py_bin .. " --version 2>&1")
        if fh then
            local line = fh:read("*l") or ""
            fh:close()
            py_ver = line:match("Python%s+(%d+%.%d+)") or ""
        end
    end

    -- ── Build display: (folder|prompt.version) ───────────────────────
    -- Omit prompt when it equals the folder name or is absent.
    local ver_part = py_ver ~= "" and (" " .. py_ver) or ""
    local inner
    if prompt_name and prompt_name ~= folder_name then
        inner = folder_name .. "|" .. prompt_name .. ver_part
    else
        inner = folder_name .. ver_part
    end
    local full_str = "%#lualine_x_filetype_DevIconLua_normal#" .. "(󰆧 " .. inner .. ")"

    _cache[venv_path] = { mtime = mtime, full_str = full_str }
    return full_str
end

-- Clear cache on VenvActivated (covers reinstall + re-select at same path)
vim.api.nvim_create_autocmd("User", {
    pattern = "VenvActivated",
    group = vim.api.nvim_create_augroup("zaman_nvim_venv_cache", { clear = true }),
    callback = function()
        _cache = {}
    end,
})

return M
