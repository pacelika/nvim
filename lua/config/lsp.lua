local success
local lspconfig

local lsp_signature = require('lsp_signature')

success,lspconfig = pcall(require, "lspconfig")

if not success then
    return print("ERROR: lspconfig is not installed")
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

capabilities.textDocument.signatureHelp = {
    dynamicRegistration = true,
    signatureInformation = {
        documentationFormat = { "markdown", "plaintext" },
        parameterInformation = { labelOffsetSupport = true },
    },
}

local lsp_servers = {
    "lua_ls",
    "pyright",
    {
        "rust_analyzer",
        "rust-analyzer",
        opts = {
            settings = {
                ['rust-analyzer'] = {},
            },
            capabilities = capabilities
        },
    },
    "zls",
    "csharp_ls",
}

table.insert(lsp_servers,{
    "clangd",
    opts = {
        capabilities = capabilities,
        cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
    }
})

local default_opts = {
    capabilities = capabilities
}

for _,server in ipairs(lsp_servers) do
    if type(server) == "string" then
        if vim.fn.executable(server) == 1 and lspconfig[server] then
            lspconfig[server].setup(default_opts)
        end
    elseif type(server) == "table" then
        if vim.fn.executable(server[2] or server[1]) == 1 and lspconfig[server[1]] then
            lspconfig[server[1]].setup(server.opts or default_opts)
        end
    end
end

vim.diagnostic.config({
    virtual_text = true,
})

vim.api.nvim_create_autocmd("LspAttach",{
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then return end

        if client.supports_method("textDocument/formatting") then
            vim.keymap.set('n', '<Space>rf', ":lua vim.lsp.buf.format()<cr>", { silent = true,desc = 'Refactor format' })
            vim.api.nvim_create_autocmd("BufWritePre",{
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({bufnr = args.buf,id = client.id})
                end
            })
        end
    end
})

vim.keymap.set('n', '<Space>fsr', ":lua vim.lsp.buf.references()<cr>", { silent = true, desc = 'Find Symbol references' })
vim.keymap.set('n', '<Space>fsw', ":lua vim.lsp.buf.workspace_symbol()<cr>", { silent = true, desc = 'Find Symbol workspace' })
vim.keymap.set('n', '<Space>r.', ":lua vim.lsp.buf.code_action()<cr>", {
    silent = true,
    desc = 'Refactor code action',
})

require "config.cmp"
