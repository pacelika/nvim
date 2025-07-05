local success, lspconfig = pcall(require, "lspconfig")

local notify = require("notify")

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
    { "lua_ls",  "lua-language-server" },
    {
        "rust_analyzer",
        "rust-analyzer",
        opts = {
            settings = {
                ['rust-analyzer'] = {},
            },
            capabilities = capabilities
        },
        required = false,
    },
    { "ts_ls",   "tsserver",           required = true },
    { "pyright", required = false },
    { "zls",     required = false },
    { "gopls",   required = false },
}

table.insert(lsp_servers, {
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
    capabilities = capabilities,
    on_exit = function(code, signal, client_id)
        notify(("%s"):format(("Disconnected with code: %d"):format(code)), "error", {
            title = ("LSP"):format(),
            icon = "",
        })
    end,
}

local cached_clients = {}
local missing_servers = {}

for _, server in ipairs(lsp_servers) do
    if type(server) == "string" then
        if vim.fn.executable(server) == 1 and lspconfig[server] then
            lspconfig[server].setup(default_opts)
        else
            if not cached_clients[server] then
                table.insert(missing_servers, { server })
            end
        end
    elseif type(server) == "table" then
        if vim.fn.executable(server[2] or server[1]) == 1 and lspconfig[server[1]] then
            lspconfig[server[1]].setup(server.opts or default_opts)
        else
            if not cached_clients[server[1]] then
                table.insert(missing_servers, { server[2] or server[1], required = server.required })
            end
        end
    end
end

if #missing_servers > 0 then
    local message = ""
    local last_index = 0

    for index, data in ipairs(missing_servers) do
        if index ~= #missing_servers then
            if data.required == nil or data.required == true then
                message = message .. data[1] .. "\n"
                last_index = last_index + 1
            end
        else
            if data.required == nil or data.required == true then
                message = message .. data[1]
                last_index = last_index + 1
            end
        end
    end

    if last_index ~= #missing_servers then
        message = message:sub(1, #message - 1)
    end

    if #message ~= 0 then
        notify(("%s"):format(message), "info", {
            title = ("LSP Not Installed"):format(),
            icon = "",
        })
    end
end

vim.diagnostic.config({
    virtual_text = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then return end

        if not cached_clients[client.name] then
            notify(("Connected"):format(), "info", {
                title = ("%s LSP"):format(client.name),
                icon = "",
                timeout = 1,
            })

            cached_clients[client.name] = client
        end

        if client.supports_method("textDocument/formatting") then
            vim.keymap.set('n', '<Space>rf', ":lua vim.lsp.buf.format()<cr>", { silent = true, desc = 'Refactor format' })
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                end
            })
        end
    end
})

vim.keymap.set('n', '<Space>fsr', ":lua vim.lsp.buf.references()<cr>", { silent = true, desc = 'Find Symbol references' })

vim.keymap.set('n', '<Space>fsw', ":lua vim.lsp.buf.workspace_symbol()<cr>",
    { silent = true, desc = 'Find Symbol workspace' })

vim.keymap.set('n', '<Space>r.', ":lua vim.lsp.buf.code_action()<cr>", {
    silent = true,
    desc = 'Refactor code action',
})

vim.keymap.set('n', '<Space>rr', ":lua vim.lsp.buf.rename()<cr>", {
    silent = true,
    desc = 'Refactor rename',
})

require "config.cmp"
