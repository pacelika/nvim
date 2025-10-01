local M = {}
local file = require "utils.file"
local Git = require "utils.git"

local ConfigUpdateCommand = "ConfigUpdate"

function M.setup()
    require "plugins"

    vim.api.nvim_create_user_command("ConfigOpen", function()
        local config_path = file.get_config_path()
        vim.cmd("cd " .. config_path)
        vim.cmd("e init.lua")
    end, {})

    vim.api.nvim_create_user_command(ConfigUpdateCommand, function()
        local old_project_dir = Git.is_git_repo() and Git.get_git_root()
        local old_file_path = vim.fn.expand('%:p')
        local config_path = file.get_config_path()
        vim.cmd("cd " .. config_path)
        vim.cmd("e init.lua")
        vim.cmd("Git pull")
        vim.cmd("source %")

        -- checks if we were in a git project -- 
        if old_project_dir then
            vim.cmd("cd " .. old_project_dir)
            vim.cmd("e "..old_file_path)
        else
            print(":"..ConfigUpdateCommand or "".. " Could not find old project path")
            vim.cmd("cd " .. vim.fn.getcwd())
            vim.cmd("e "..old_file_path)
        end
    end, {})

    require "config.telescope"
    require "config.file_explorer"

    require "config.treesj"
    require "config.tmux_nav"
    require "config.terminal"

    require "config.which_key"
    require "config.harpoon"

    require "config.git"

    require "config.treesitter"
    require "config.lsp"
end

return M
