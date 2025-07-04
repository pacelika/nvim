local success, telescope = pcall(require, "telescope")

if not success then return print "telescope is not installed" end

require("telescope.themes").get_dropdown {}

telescope.setup({
    defaults = {
        file_ignore_patterns = {
            ".git/*",
            "node_modules/*",
            "target/*",
            "bin/*",
            "cache",
            "CMakeFiles",
            "out",
            "class",
            "pdf",
            "dll",
            "exe",
        },
    }
})

xpcall(function()
    telescope.load_extension("ui-select")
    telescope.load_extension('harpoon')
end, print)

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<Space>ff', builtin.find_files, { desc = 'Find files', silent = true })
vim.keymap.set('n', '<Space>fg', builtin.live_grep, { desc = 'Find with grep', silent = true })
vim.keymap.set('n', '<Space>ft', ":TodoTelescope<cr>", { desc = 'Find todos', silent = true })
vim.keymap.set('n', '<Space>fsf', builtin.lsp_document_symbols, { desc = 'Find Symbol functions', silent = true })
vim.keymap.set('n', '<Space>fb', builtin.buffers, { desc = 'Find buffers', silent = true })
vim.keymap.set('n', '<Space>fh', builtin.help_tags, { desc = 'Find help tags', silent = true })
vim.keymap.set('n', '<Space>fk', builtin.keymaps, { desc = 'Find keymaps', silent = true })
