return {
    {
        'nvim-treesitter/nvim-treesitter',
        event = { "InsertEnter" },
        run = function()
            local M = require('nvim-treesitter.install')
            M.compilers = { vim.fn.getenv('CC'), "cc", "gcc", "clang", "cl", "zig" }
            M.prefer_git = false
            M.update({ with_sync = true })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
    },
}
