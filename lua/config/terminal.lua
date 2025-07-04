vim.keymap.set('t', '<C-\\>', [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Terminal normal mode" })

vim.keymap.set('t', '<A-q>', [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Terminal normal mode" })

vim.keymap.set('n', ';;', ":FloatermToggle<cr>", { noremap = true, silent = true, desc = "Terminal toggle" })

vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>:FloatermHide<CR>]],
    { noremap = true, silent = true, desc = "Terminal toggle" })

vim.keymap.set('n', '<Space>tk', ":FloatermNext<cr>", { noremap = true, silent = true, desc = "Terminal next" })
vim.keymap.set('n', '<Space>tj', ":FloatermPrev<cr>", { noremap = true, silent = true, desc = "Terminal prev" })
vim.keymap.set('n', '<Space>tn', ":FloatermNew<cr>", { noremap = true, silent = true, desc = "Terminal new" })

vim.keymap.set('t', '<C-j>', [[<C-\><C-n>:FloatermPrev<CR>]], { noremap = true, silent = true, desc = "Terminal prev" })
vim.keymap.set('t', '<C-k>', [[<C-\><C-n>:FloatermNext<CR>]], { noremap = true, silent = true, desc = "Terminal next" })
vim.keymap.set('t', '<C-n>', [[<C-\><C-n>:FloatermNew<CR>]], { noremap = true, silent = true, desc = "Terminal new" })
vim.keymap.set('t', '<C-d>', [[<C-\><C-n>:FloatermKill<CR>]], { noremap = true, silent = true, desc = "Terminal kill" })

vim.keymap.set('t', '<C-f>', [[<C-\><C-n>:FloatermUpdate --width=0.5 --height=0.5<cr>]],
    { noremap = true, silent = true, desc = "Terminal toggle floating" })

vim.keymap.set('t', '<C-l>', [[<C-\><C-n>:FloatermUpdate --width=1.0 --height=1.0<cr>]],
    { noremap = true, silent = true, desc = "Terminal toggle full screen" })

local last_command = nil

local os_name = vim.loop.os_uname().sysname

local build_commands = {
    ["build.zig"] = "zig build run",
    ["CMakeLists.txt"] = "cmake -S .",
    ["package.json"] = "npm run dev",
    ["Cargo.toml"] = "cargo run",
}

if os_name == "Windows_NT" then
    build_commands["Makefile"] = "mingw32-make"
else
    build_commands["Makefile"] = "make"
end

function Get_compile_command()
    for file_name, cmd in pairs(build_commands) do
        local file = vim.fn.getcwd() .. "/" .. file_name
        local stat = vim.loop.fs_stat(file)

        if stat then return cmd end
    end
end

function Find_terminal_buf()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
        if buftype == 'terminal' then
            return bufnr
        end
    end
end

function Run_command_in_term()
    local command = last_command or Get_compile_command()

    if not command then
        Prompt_command()
        return
    end

    if command == nil and last_command == nil then return end

    if not Find_terminal_buf() then
        vim.cmd("FloatermNew")

        if os_name == "Windows_NT" then
            vim.cmd("FloatermSend " .. "cls")
        else
            vim.cmd("FloatermSend " .. "clear")
        end
    else
        vim.cmd("FloatermShow")
    end

    last_command = command

    if last_command ~= nil then
        vim.cmd("FloatermSend " .. last_command)
    else
        vim.cmd("FloatermHide")
    end
end

function Prompt_command()
    local cmd = nil

    if last_command == nil then
        last_command = Get_compile_command()
    end

    if last_command ~= nil then
        cmd = vim.fn.input("Set terminal command: ", last_command)
    else
        cmd = vim.fn.input("Set terminal command: ")
    end

    if cmd == ";" then
        last_command = Get_compile_command()
        return
    elseif cmd == "" or cmd == nil then
        return
    else
        last_command = cmd
    end

    Run_command_in_term()
end

vim.keymap.set('n', '\\\\', Run_command_in_term, { noremap = true, silent = true, desc = "Terminal run command" })
vim.keymap.set('n', '\\=', Prompt_command, { noremap = true, silent = true, desc = "Terminal set command" })
