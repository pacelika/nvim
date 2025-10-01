local M = {}

function M.get_git_root()
  return vim.fn.system('git rev-parse --show-toplevel'):gsub("\n", "") 
end

function M.is_git_repo()
    local buf_path = vim.api.nvim_buf_get_name(0)
    if buf_path == "" then return false end

    local file_dir = vim.fn.fnamemodify(buf_path, ":h")
    local os_name = vim.loop.os_uname().sysname 

    local cmd

    if os_name == "Windows_NT" then
        cmd = string.format('cd /d "%s" && git rev-parse --is-inside-work-tree 2>nul', file_dir)
    else
        cmd = string.format('cd "%s" && git rev-parse --is-inside-work-tree 2>/dev/null', file_dir)
    end

    local handle = io.popen(cmd)
    if not handle then return false end

    local result = handle:read('*a')
    handle:close()

    return result:match("true") ~= nil
end

return M
