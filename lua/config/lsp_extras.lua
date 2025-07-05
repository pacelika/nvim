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
