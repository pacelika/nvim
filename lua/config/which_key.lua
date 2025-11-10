xpcall(function()
    local wk = require("which-key")

    wk.setup({
        icons = {
            breadcrumb = "",
            separator = "",
            group = "+",
            ellipsis = "…",
            mappings = false,
            keys = {},
            disable = {},
            colors = false,
            show_help = false,
            show_keys = false,
        }
    })

    if not wk then return print("ERROR: which-key is missing") end
    if not wk.add then return end

    wk.add({"<Space>f",group = "Find"})
    wk.add({"<Space>fs",group = "Symbol"})

    wk.add({"<Space>g",group = "Git"})
    wk.add({"<Space>ga",group = "Add"})
    wk.add({"<Space>gv",group = "View"})
    wk.add({"<Space>gc",group = "Commit"})

    wk.add({"<Space>k",group = "Document"})
    wk.add({"<Space>h",group = "Harpoon"})
    wk.add({"<Space>r",group = "Refactor"})
    wk.add({"<Space>d",group = "Directory"})

    wk.add({"<Space>t",group = "Terminal"})
end, print)
