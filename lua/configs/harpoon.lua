local MIN_INDEX = 1
local MAX_INDEX = 9

local harpoon_ui = require "harpoon.ui"
local harpoon_mark = require "harpoon.mark"
local harpoon_tmux = require "harpoon.tmux"

vim.keymap.set('n', '<Space>hh', harpoon_ui.toggle_quick_menu, { desc = 'Harpoon toggle ui' })
vim.keymap.set('n', '<Space>ha', harpoon_mark.add_file, { desc = 'Harpoon add file' })
vim.keymap.set('n', '<Space>hj', harpoon_ui.nav_prev, { desc = 'Harpoon nav prev' })
vim.keymap.set('n', '<Space>hk', harpoon_ui.nav_next, { desc = 'Harpoon nav next' })
vim.keymap.set('n', '<Space>hf', ":Telescope harpoon marks<cr>", { desc = 'Harpoon find mark' })

for i = MIN_INDEX,MAX_INDEX do
    vim.keymap.set('n', '<Space>h'..tostring(i), function() harpoon_ui.nav_file(i) end, {
        desc = 'Harpoon nav file '..tostring(i),
    })
end
