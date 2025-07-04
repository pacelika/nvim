local M = {}

function M.setup()
    require "plugins"

    require "config.telescope"
    require "config.file_explorer"
    require "config.nvim_tree"

    require "config.treesj"
    require "config.tmux_nav"
    require "config.terminal"

    require "config.which_key"
    require "config.harpoon"

    require "config.git"
    require "gitsigns"

    require "config.treesitter"
    require "config.lsp"
end

return M
