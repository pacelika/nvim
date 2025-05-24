local M = {}

function M.setup()
     require "plugins"

     require "configs.telescope"
     require "configs.file_explorer"
     require "configs.treesj"
     require "configs.tmux_nav"
     require "configs.terminal"

     require "configs.which_key"
     require "configs.harpoon"

     require "configs.git"
     require "gitsigns"

     require "configs.treesitter"
     require "configs.lsp"
end

return M
