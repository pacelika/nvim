local plugins = {}

if vim.fn.has("win32") ~= 1 or vim.fn.has("win64") ~= 1 then
    table.insert(plugins,
        {
            "christoomey/vim-tmux-navigator",
            cmd = {
                "TmuxNavigateLeft",
                "TmuxNavigateDown",
                "TmuxNavigateUp",
                "TmuxNavigateRight",
                "TmuxNavigatePrevious",
            },
        }
    )
end

-- table.insert(plugins, {
--     'romgrk/barbar.nvim',
--     init = function()
--         vim.g.barbar_auto_setup = false
--     end
-- })
--
return plugins
