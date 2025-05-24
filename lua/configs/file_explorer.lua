local choice = "netrw"

if choice == "netrw" then
    vim.keymap.set('n', '<Space>fm',":Ex<cr>", { desc = 'Find file explorer' })
    return
else
	vim.g.loaded_netrwPlugin = 1
	vim.g.loaded_netrw = 1
    return
end
