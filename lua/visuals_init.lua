local M = {}

local color_names = {"desert","catppuccin-mocha"}

function M.setup()
    vim.api.nvim_create_augroup('MyColorSchemeGroup', { clear = true })

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = 'MyColorSchemeGroup',
      pattern = '*',
      callback = function()
        vim.cmd('highlight EndOfBuffer ctermbg=NONE guibg=NONE')
      end
    })

    local color_name = color_names[2]

    assert(color_name)

    local success,error_message = pcall(vim.cmd.colorscheme, color_name)

    if not success then
        print(error_message)
    end
end

return M
