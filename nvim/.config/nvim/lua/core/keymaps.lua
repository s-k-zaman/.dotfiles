local map = require("utils.keymapper").keymap

-- file operations
vim.keymap.set("n", "<leader>fs", function()
    vim.cmd("normal! ggVG")
    vim.notify("Selected all", vim.log.levels.INFO)
end, { desc = "Select all" })

vim.keymap.set("n", "<leader>fc", function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local content = table.concat(lines, "\n")
    vim.fn.setreg("+", content)
    vim.notify("File contents copied", vim.log.levels.INFO)
end, { desc = "Copy file contents" })

vim.keymap.set("n", "<leader>fp", function()
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
    if path == "" then
        vim.notify("No file path available", vim.log.levels.WARN)
        return
    end
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy relative file path" })

vim.keymap.set("n", "<leader>fP", function()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
        vim.notify("No file path available", vim.log.levels.WARN)
        return
    end
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy full file path" })

-- motion
vim.keymap.set("n", "k", "gk", { desc = "Move up (wrapped)" })
vim.keymap.set("n", "j", "gj", { desc = "Move down (wrapped)" })
if CENTER_SCROLL then
    vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
    vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
end

-- editing
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste (keep register)" })
-- stylua: ignore
vim.keymap.set( "n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word (buffer)" })
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("n", "J", "mzJ`z") -- keep cursor in place on J

-- move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- search
-- saner n/N behavior: https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- disable Ex mode
map("n", "Q", "<nop>")

-- quickfix / location list
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location list" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix list" })

-- inspect
if vim.fn.has("nvim-0.9.0") == 1 then
    vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect position" })
end

-- windows
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split below" })
vim.keymap.set("n", "<leader>w\\", "<C-W>v", { desc = "Split right" })
map("n", "<C-Up>", "resize +2", { desc = "Increase window height" })
map("n", "<C-Down>", "resize -2", { desc = "Decrease window height" })
map("n", "<C-Left>", "vertical resize -2", { desc = "Decrease window width" })
map("n", "<C-Right>", "vertical resize +2", { desc = "Increase window width" })

-- tabs
map("n", "<leader><tab>o", "tablast", { desc = "Last tab" })
map("n", "<leader><tab>O", "tabfirst", { desc = "First tab" })
map("n", "<leader><tab><tab>", "tabnew", { desc = "New tab" })
map("n", "<leader><tab>h", "tabprevious", { desc = "Previous tab" })
map("n", "<leader><tab>l", "tabnext", { desc = "Next tab" })
map("n", "<leader><tab>d", "tabclose", { desc = "Close tab" })

-- buffers
map("n", "<leader>bl", "bnext", { desc = "Next buffer", noremap = false, remap = true })
map("n", "<leader>bh", "bprevious", { desc = "Prev buffer", noremap = false, remap = true })
-- INFO: dont use tab mapping like tab + tab... as it will colide with c+o, c+o sends signal of Tab to terminals
map("n", "<leader>bb", "e #", { desc = "Alternate buffer" })
map("n", "<leader>`", "e #", { desc = "Alternate buffer" })

-- format
map("n", "<leader>I", "Format", { desc = "Format file (conform|lsp)" })

-- toggles
vim.api.nvim_set_keymap("n", "<leader>tz", ":set wrap!<CR>", { desc = "Toggle word wrap", noremap = true })

-- nb notes
map("n", "<leader>nr", "<cmd>!nb sync<cr>", { desc = "nb sync" })
-- TODO: escape # symbol in note title
map(
    "n",
    "<leader>na",
    '<cmd>!tmux neww -c "#{pane_current_path}" "note-accessor"<cr>',
    { desc = "Note accessor", silent = true }
)
