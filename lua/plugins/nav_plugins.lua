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

return plugins
