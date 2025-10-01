local telescope_builtin = require('telescope.builtin')
local Git = require "utils.git"

local function is_diffview_open()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match("^diffview://") then return true end
    end
end

local function find_logview_buffer()
    local path = nil
    local os_name = vim.loop.os_uname().sysname 

    if os_name == "Windows_NT" then
        path = "\\AppData\\Local\\Temp\\nvim.0"
    elseif os_name == "Linux" then
        path = "^/tmp/nvim."
    else
        path = "^/private/var/folders/tr/"
    end

    for _, bufid in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufid) then
            local buf_name = vim.api.nvim_buf_get_name(bufid)
            if buf_name:find(path) then
                return bufid,buf_name
            end
        end
    end
end

local function toggle_git_diffview()
    if is_diffview_open() then
        vim.cmd.DiffviewClose()
    elseif not is_diffview_open() then
        if Git.is_git_repo() then
            vim.cmd.DiffviewOpen()
        else
            print("INFO: This workspace does not have a .git folder")
        end
    end
end

local function toggle_git_log_buffer()
    local buf_id = find_logview_buffer()

    if buf_id then
        vim.api.nvim_buf_delete(buf_id,{force = true})
    elseif not buf_id then
        vim.cmd("Git log")
    end
end

vim.keymap.set('n', '<M-g>', toggle_git_diffview, { desc = 'Git view diff' })
vim.keymap.set('n', '<Space>gvl',toggle_git_log_buffer, { desc = 'Git log' })
vim.keymap.set('n', '<Space>gvc', telescope_builtin.git_commits, { desc = 'Git view commit' })

vim.keymap.set('n', '<Space>ga.',":Git add .<cr>", { desc = 'Git add .' })
vim.keymap.set('n', '<Space>gaf',":Git add ", { desc = 'Git add file' })
vim.keymap.set('n', '<Space>gcc',":Git commit<cr>", { desc = 'Git commit' })
vim.keymap.set('n', '<Space>gP',":Git push<cr>", { desc = 'Git push' })
vim.keymap.set('n', '<Space>g!',":Git pull<cr>", { desc = 'Git push' })
