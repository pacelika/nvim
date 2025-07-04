local M = {}

local string_func = require "utils.string_func"

function M.setup()
    require "plugins"

    vim.keymap.set('n', '<Space>rc', string_func.buf_cap_word, {
        silent = true,
        desc = 'Refactor capitialize',
    })

    vim.api.nvim_create_user_command("Config", function()
        local config_dir = os.getenv("LOCALAPPDATA")

        if not config_dir then
            config_dir = vim.fn.expand("~")

            if not config_dir then
                return print("ERROR: FAILED TO GET CONFIG DIR")
            end

            config_dir = config_dir .. "/.config"
        end

        local config_path = config_dir .. "/nvim"

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
