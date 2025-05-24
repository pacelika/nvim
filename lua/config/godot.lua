-- FYI: Godot Editor -> Editor Settings -> Text Editor -> External -> Exec Flag -- server ./godothost --remote-send "<C-\><C-N>:n {file} <CR>{line}G{col}|"
-- FYI: Godot Editor -> Script -> Debug -> Debug with external editor
-- FYI: Godot Editor -> Editor Settings -> Network -> Debug Adapter -> Remote Port: 6006

local gdproject = io.open(vim.fn.getcwd()..'/project.godot', 'r')

if gdproject then
    io.close(gdproject)
    -- vim.fn.serverstart './godothost'
end

if not gdproject then return end

local os_info = vim.loop.os_uname()

if os_info.sysname == "Linux" then
    vim.g.godot_executable = os.getenv("HOME") .. "/godot/Godot"
elseif os_info.sysname == "Darwin" then
    vim.g.godot_executable = "/Applications/Godot.app/Contents/MacOS/Godot"
elseif os_info.sysname == "Windows" then
    vim.g.godot_executable = "C:/godot/Godot.exe"
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

if not capabilities then
    return print("Failed to find capabilities module in godot.lua")
end

capabilities.textDocument.completion.completionItem.snippetSupport = true

if os_info.sysname == "Windows"  then
    capabilities.cmd = {"ncat","localhost",os.getenv "GDScript_Port" or "6005"}
end

local ok, lspconfig = pcall(require, "lspconfig")

if not ok then return print "Godot missing lspconfig" end

if lspconfig.gdscript then
    lspconfig.gdscript.setup(capabilities)
else
    print("No property 'gdscript' for lspconfig")
end

local dap = require "dap"

if not dap then return print "dap is not installed" end

dap.adapters.godot = {
    type = "server",
    host = "127.0.0.1",
    port = 6006
}

dap.configurations.gdscript = {{
    type = "godot",
    request = "launch",
    name = "Launch scene",
    project = "${workspaceFolder}",
    launch_scene = true
}}
