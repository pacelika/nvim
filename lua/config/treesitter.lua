local success, config = pcall(require, "nvim-treesitter.configs")

if not success then return print "something is wrong with treesitter.configs" end

config.setup {
    build = ":TSUpdate",
    ensure_installed = {
        "c",
        "go",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "rust",
        "javascript",
        "gdscript"
    },
    sync_install = false,
    auto_install = true,
    ignore_install = { "javascript" },

    indent = { enable = true },

    highlight = {
        enable = true,
        disabled_t = { "c", "rust" },
        disable = function(lang, buf)
            if vim.api.nvim_buf_get_option(0, "filetype") ~= "TelescopePrompt" then
                if lang == "cpp" then
                    pcall(vim.cmd.TSDisable, "rainbow")
                else
                    pcall(vim.cmd.TSEnable, "rainbow")
                end
            end
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        additional_vim_regex_highlighting = false,
    },
}
