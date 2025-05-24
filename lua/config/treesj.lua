require('treesj').setup({use_default_keymaps = false})

vim.keymap.set('n', '<Space>r{', ":TSJJoin<cr>", { desc = 'Refactor line join' })
vim.keymap.set('n', '<Space>r}', ":TSJSplit<cr>", { desc = 'Refactor line split' })
