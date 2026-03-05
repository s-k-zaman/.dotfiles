local function fold_virt_handler(virtText, lnum, endLnum, width, truncate)
    local lineCount = endLnum - lnum
    local info = (" ..... 󱞱 %d lines "):format(lineCount)
    local infoWidth = vim.fn.strdisplaywidth(info)
    local fillChar = "─"
    local minFill = 2

    -- clip content so there's room for info + at least minFill dashes
    local contentMax = width - infoWidth - minFill
    if contentMax < 0 then
        contentMax = 0
    end

    local newVirtText = {}
    local curWidth = 0

    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if contentMax > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
            curWidth = curWidth + chunkWidth
        else
            chunkText = truncate(chunkText, contentMax - curWidth)
            table.insert(newVirtText, { chunkText, chunk[2] })
            curWidth = curWidth + vim.fn.strdisplaywidth(chunkText)
            break
        end
    end

    table.insert(newVirtText, { info, "MoreMsg" })

    local fillWidth = width - curWidth - infoWidth
    if fillWidth > 0 then
        table.insert(newVirtText, { fillChar:rep(fillWidth), "Comment" })
    end

    return newVirtText
end

return {
    {
        "kevinhwang91/nvim-ufo",
        event = "BufReadPost",
        dependencies = { "kevinhwang91/promise-async" },
        init = function()
            -- Must be set before the first buffer opens; ufo requires foldlevel=99 to keep folds open
            vim.o.foldcolumn = "0"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:"
        end,
        config = function()
            local ftFoldProviderMap = {
                vim = "indent",
                git = "",
            }
            -- 3-provider chain: lsp → treesitter → indent (via promise fallback)
            local function selector(bufnr)
                local function fallback(err, provider)
                    if type(err) == "string" and err:match("UfoFallbackException") then
                        return require("ufo").getFolds(bufnr, provider)
                    end
                    return require("promise").reject(err)
                end
                return require("ufo")
                    .getFolds(bufnr, "lsp")
                    :catch(function(err)
                        return fallback(err, "treesitter")
                    end)
                    :catch(function(err)
                        return fallback(err, "indent")
                    end)
            end

            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return ftFoldProviderMap[filetype] or selector
                end,
                fold_virt_text_handler = fold_virt_handler,
            })

            local ufo = require("ufo")
            -- stylua: ignore start
            vim.keymap.set("n", "zR", ufo.openAllFolds,         { desc = "Open all folds" })
            vim.keymap.set("n", "zM", ufo.closeAllFolds,        { desc = "Close all folds" })
            vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open one fold level" })
            vim.keymap.set("n", "zm", ufo.closeFoldsWith,       { desc = "Close one fold level" })
            -- stylua: ignore end
            vim.keymap.set("n", "zp", function()
                local winid = ufo.peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end, { desc = "Peek fold (or hover)" })
        end,
    },
}
