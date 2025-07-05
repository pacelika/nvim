local M = {}
local file = require "utils.file"

function M.setup()
    require "plugins"

    vim.api.nvim_create_user_command("Config", function()
        local config_path = file.get_config_path()
        vim.cmd("cd " .. config_path)
        vim.cmd("e init.lua")
    end, {})

    require "config.telescope"
    require "config.file_explorer"
    require "config.nvim_tree"
    -- require "config.barbar"

    require "config.treesj"
    require "config.tmux_nav"
    require "config.terminal"

    require "config.which_key"
    require "config.harpoon"

    require "config.git"
    require "gitsigns"

    require "config.treesitter"
    require "config.lsp"
end

return M
