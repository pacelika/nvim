local M = {}
local vo = vim.opt

function M.setup()
    vo.number = true
    vo.background = "dark"
    vo.termguicolors = true

    vo.tabstop = 4
    vo.softtabstop = 4
    vo.shiftwidth = 4

    vo.smarttab = true
    vo.smartindent = true
    vo.expandtab = true

    vo.autoindent = true
    vo.mouse = "a"
    vo.cursorline = true
    vo.number = true
    vo.nu = true
    vo.relativenumber = true
    vo.numberwidth = 6
    vo.timeoutlen = 500
    vo.updatetime = 200
    vo.wrap = true
    vo.clipboard = "unnamedplus"

    vo.syntax = "on"
    vo.ruler = true
    vo.title = true
    vo.hidden = true
    vo.ttimeoutlen = 0
    vo.wildmenu = true
    vo.showcmd = true
    vo.showmatch = true
    vo.inccommand = "split"
    vo.splitright = true
    vo.splitbelow = true

    vo.foldcolumn = "1"
    vo.foldlevel = 99
    vo.foldlevelstart = 99
    vo.foldenable = true

    vo.guicursor = ""
    vo.inccommand = "split"
    vo.signcolumn = "yes"
    vo.splitbelow = true
    vo.splitright = true
    vo.encoding = "UTF-8"

    vo.swapfile = false
    vo.backup = false
    vo.undofile = true

    vo.hlsearch = false
    vo.incsearch = true

    vo.tags = "./tags;/"
    vo.omnifunc = "v:lua.vim.lsp.omnifunc"

    vim.scrolloff = 8
    vo.isfname:append("@-@")
    vo.updatetime = 50
end

return M
