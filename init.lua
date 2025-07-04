local plugin_init = require "plugin_init"
local visuals_init = require "visuals_init"

local vim_opt = require("vim_opt")
local vim_g = require("vim_g")

xpcall(function()
    plugin_init.setup()
    vim_g.setup()
    vim_opt.setup()
    visuals_init.setup()

    vim.cmd("autocmd BufLeave,BufWinLeave * silent! mkview")
    vim.cmd("autocmd BufReadPost * silent! loadview")
end, print)

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
