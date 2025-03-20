if vim.fn.has("win32") ~= 1 or vim.fn.has("win64") ~= 1 then
    vim.keymap.set('n', '<c-j>',":TmuxNavigateDown<cr>", { desc = 'Tmux down' })
    vim.keymap.set('n', '<c-k>',":TmuxNavigateUp<cr>", { desc = 'Tmux up' })

    vim.keymap.set('n', '<c-h>',":TmuxNavigateLeft<cr>", { desc = 'Tmux left' })
    vim.keymap.set('n', '<c-l>',":TmuxNavigateRight<cr>", { desc = 'Tmux right' })
    vim.keymap.set('n', '<c-\\>',":TmuxNavigatePrevious<cr>", { desc = 'Tmux prev' })
end
