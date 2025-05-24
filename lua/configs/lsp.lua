local success
local lspconfig

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
{
    "clangd",
    {
        capabilities = capabilities,

        cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
}
},
    "lua_ls","pyright","rust_analyzer","zls","csharp_ls",
}

for _,server in ipairs(lsp_servers) do
    if type(server) == "string" then
        if vim.fn.executable(server) == 1 then
            lspconfig[server].setup({
                capabilities = capabilities
            })
        end
    elseif type(server) == "table" then
        if vim.fn.executable(server[1]) == 1 then
            lspconfig[server[1]].setup(server[2])
        end
    end
end

vim.diagnostic.config({
    virtual_text = true,
})

vim.keymap.set('n', '<Space>fsr', ":lua vim.lsp.buf.references()<cr>", { desc = 'Find Symbol references' })
vim.keymap.set('n', '<Space>fsw', ":lua vim.lsp.buf.workspace_symbol()<cr>", { desc = 'Find Symbol workspace' })
vim.keymap.set('n', '<Space>r.', ":lua vim.lsp.buf.code_action()<cr>", {
    desc = 'Refactor code action',
})

require "configs.cmp"
