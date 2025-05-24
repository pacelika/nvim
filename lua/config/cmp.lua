local ok,cmp = pcall(require, "cmp")

if not ok then return print("ERROR: cmp is not installed") end

cmp.setup({
    sources = {
        { name = "nvim_lsp" },
    },
    mapping = {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),

        ["<up>"] = cmp.mapping.select_prev_item(),
        ["<down>"] = cmp.mapping.select_next_item(),

        ["<left>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<right>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),

        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),

        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }
})

require "lsp_signature".setup({
  bind = true,
  handler_opts = {
    border = "rounded"
  }
})

cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        {
            name = "cmdline",
            option = {
                ignore_cmds = { "Man", "!" },
            },
        },
    }),
})

