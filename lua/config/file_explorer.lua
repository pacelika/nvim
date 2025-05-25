vim.keymap.set('n', '<Space>dm',":Ex<cr>", { desc = 'Directory file manager' })

local mini_files = require("mini.files")

vim.keymap.set('n', '<Space>dd',function()
    mini_files.open(vim.api.nvim_buf_get_name(0),true)
end, { desc = 'Directory open' })

vim.keymap.set('n', '<Space>d.',function()
    mini_files.open(vim.fn.getcwd(),true)
end, { desc = 'Directory open cwd' })
