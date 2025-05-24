local plugin_init = require "plugin_init"
local visuals_init = require "visuals_init"

local vim_opt = require("vim_opt")
local vim_g = require("vim_g")

xpcall(function()
    plugin_init.setup()
    visuals_init.setup()
    vim_opt.setup()
    vim_g.setup()
end,print)

vim.cmd("autocmd BufLeave,BufWinLeave * silent! mkview")
vim.cmd("autocmd BufReadPost * silent! loadview")
