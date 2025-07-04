local exports = {}

local strings = require "utils.strings"

function exports.buf_cap_word()
    local current_line = vim.api.nvim_get_current_line()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local word = select(2, pcall(strings.get_word_by_index, current_line, col + 1))

    if not word then return end

    local new_line = current_line:gsub(word, strings.capitilize_word(word, true))

    vim.api.nvim_buf_set_lines(0, row - 1, row, true, { new_line })
end

return exports
