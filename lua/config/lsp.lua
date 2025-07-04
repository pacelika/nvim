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
    { "ts_ls",   "tsserver",           required = false },
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

local trouble = require "trouble"

local function is_trouble_open()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
        if filetype == "trouble" then
            return true
        end
    end

    return false
end

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function(args)
        local bufnr = args.buf

        local errors = vim.diagnostic.get(bufnr, {
            severity = vim.diagnostic.severity.ERROR
        })

        if #errors > 2 and not is_trouble_open() then
            vim.cmd("Trouble diagnostics")
        else
            if is_trouble_open() and #errors == 0 then
                trouble.close()
            end
        end
    end
})


local allowed_filetypes = {
    go = true,
}

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        local bufnr = args.buf
        local ft = vim.bo[bufnr].filetype

        if not allowed_filetypes[ft] then
            return
        end

        local clients = vim.lsp.get_clients({ bufnr = bufnr })

        local client = clients[1]
        if not client then return end

        if not client.supports_method("textDocument/codeAction") then
            return
        end

        local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
        params.context = { diagnostics = vim.diagnostic.get(bufnr) }

        vim.lsp.buf_request_all(bufnr, "textDocument/codeAction", params, function(results)
            for _, res in pairs(results or {}) do
                if res.result then
                    for _, action in ipairs(res.result) do
                        if action.title:lower():match("organize imports") then
                            vim.cmd(":lua vim.lsp.buf.code_action()")
                            if action.edit or action.command then
                                -- for key, value in pairs(action) do
                                --     if type(value) == "table" then
                                --         for key2, value2 in pairs(value) do
                                --             print("FROM: ", key, "KEY: ", key2, "VALUE: ", value2)
                                --         end
                                --     end
                                --     print("KEY: ", key, "VALUE: ", value)
                                --     -- vim.lsp.buf.execute_command()
                                -- end

                                -- client:exec_cmd({
                                --     title = action.title,
                                --     command = action.kind,
                                --     arguments = { bufnr },
                                -- }, { bufnr = bufnr })
                            end
                        end
                    end
                end
            end
        end)
    end,
})
