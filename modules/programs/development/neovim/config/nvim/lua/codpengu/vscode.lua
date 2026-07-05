_G.bind = vim.api.nvim_set_keymap
_G.bindv = vim.keymap.set

local opt = { noremap = false, silent = true }
local expr_opt = { noremap = false, expr = true }

-- TODO: fix this
function vscodeCommentary(...)
    local args = {...}
    if #args == 0 then
        vim.o.operatorfunc = "v:lua.vscodeCommentary"
        return "g@"
    end

    local line1, line2 = args[1], args[2]
    if not line1 then
        line1, line2 = vim.fn.line("'["), vim.fn.line("']")
    end

    vim.fn.VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
end

-- Function to open VSCode commands in visual mode
function openVSCodeCommandsInVisualMode()
    vim.cmd("normal! gv")
    local visualmode = vim.fn.visualmode()
    if visualmode == "V" then
        local startLine, endLine = vim.fn.line("v"), vim.fn.line(".")
        vim.fn.VSCodeNotifyRange("workbench.action.showCommands", startLine, endLine, 1)
    else
        local startPos, endPos = vim.fn.getpos("v"), vim.fn.getpos(".")
        vim.fn.VSCodeNotifyRangePos("workbench.action.showCommands", startPos[1], endPos[1], startPos[2], endPos[2], 1)
    end
end

-- Function to open WhichKey in visual mode
function openWhichKeyInVisualMode()
    vim.cmd("normal! gv")
    local visualmode = vim.fn.visualmode()
    if visualmode == "V" then
        local startLine, endLine = vim.fn.line("v"), vim.fn.line(".")
        vim.fn.VSCodeNotifyRange("whichkey.show", startLine, endLine, 1)
    else
        local startPos, endPos = vim.fn.getpos("v"), vim.fn.getpos(".")
        vim.fn.VSCodeNotifyRangePos("whichkey.show", startPos[1], endPos[1], startPos[2], endPos[2], 1)
    end
end

-- Better navigation
bind("n", "<C-h>", ":call VSCodeNotify('workbench.action.navigateLeft')<CR>", opt)
bind("x", "<C-h>", ":call VSCodeNotify('workbench.action.navigateLeft')<CR>", opt)
bind("n", "<C-l>", ":call VSCodeNotify('workbench.action.navigateRight')<CR>", opt)
bind("x", "<C-l>", ":call VSCodeNotify('workbench.action.navigateRight')<CR>", opt)
bind("n", "<C-j>", ":call VSCodeNotify('workbench.action.navigateDown')<CR>", opt)
bind("x", "<C-j>", ":call VSCodeNotify('workbench.action.navigateDown')<CR>", opt)
bind("n", "<C-k>", ":call VSCodeNotify('workbench.action.navigateUp')<CR>", opt)
bind("x", "<C-k>", ":call VSCodeNotify('workbench.action.navigateUp')<CR>", opt)

-- jump 10 lines when holding shift
bind("n", "<s-j>", "10j", opt)
bind("n", "<s-k>", "10k", opt)
bind("v", "<s-j>", "10j", opt)
bind("v", "<s-k>", "10k", opt)

-- escape by jk
bind("i", "jk", "<ESC>", opt)
bind("t", "jk", "<C-\\><C-n>", opt)

bind("n", "<Space>", ":call VSCodeNotify('whichkey.show')<CR>", opt)
bind("x", "<Space>", ":<C-u>lua openWhichKeyInVisualMode()<CR>", opt)
bind("x", "<C-P>", ":<C-u>lua openVSCodeCommandsInVisualMode()<CR>", opt)

-- bind("x", "<C-/>", "v:lua.vscodeCommentary()", expr_opt)
-- bind("n", "<C-/>", 'v:lua.vscodeCommentary() . "_"', expr_opt)
