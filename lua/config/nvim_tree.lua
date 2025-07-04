require("nvim-tree").setup {
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },

    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
}

vim.keymap.set('n', '<Space>dm', ":NvimTreeToggle<cr>", { silent = true, desc = 'Directory view toggle' })

vim.keymap.set('n', '<Space>df', ":NvimTreeFocus<cr>", { silent = true, desc = 'Directory view focus' })

vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
            if bufname:match("NvimTree_") then
                vim.api.nvim_win_close(win, true)
            end
        end
    end,
})
