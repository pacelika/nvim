-- Deprecated (kept for future reference) --
local defaults = {}

local JSON = require("helper.json")

local table_e = require "helper.table_e"
local file_data = require "helper.file_data"

local preferences = require "preferences"

if not preferences then return print "failed to fetch preferences in keymaps.lua" end

local file = require "helper.file"

local SPACE_S = "<Space>"
local LEADER_S = "<leader>"
local ENTER_S = "<CR>"

local ENTER = "cr"
local LEFT_ARROW = "left"
local RIGHT_ARROW = "right"
local UP_ARROW = "up"
local DOWN_ARROW = "down"

local ALT = function(key)
    return "<M-"..key..">"
end

local ALT_SHIFT = function(key)
    return "<M-S-"..key..">"
end

local CONTROL = function(key)
    return "<C-"..key..">"
end

local CONTROL_SHIFT = function(key)
    return "<C-S-"..key..">"
end

function isDiffviewOpen()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match("^diffview://") then return true end
    end
end

function isGitRepo()
  local handle = io.popen('git rev-parse --is-inside-work-tree 2>/dev/null')
  local result = handle:read('*a')
  handle:close()
  return result:match('true') ~= nil
end

function toggleGitDiffview()
    if isDiffviewOpen() then
        vim.cmd.DiffviewClose() 
    elseif not isDiffviewOpen() and isGitRepo() then
        vim.cmd.DiffviewOpen()
    end
end

local C = ":"
local L = "lua ->"
local E = "v."

local cmd_types = {}

defaults.goto = {
    preview = { key = "gp", cmd="goto_preview_definition", desc = "goto signature preview" },
}

defaults.lsp = {
    signature = {key = SPACE_S.."fk",desc="lsp help signature",cmd = L.."vim.lsp.buf.signature_help()"},

    code_action = {key=ALT(ENTER),cmd = L.."vim.lsp.buf.code_action()",desc = "code action"},

    goto_defination = {key = "gd",desc="goto symbol defination",cmd = L.."vim.lsp.buf.definition()"},
    goto_defination_intellij_idea = {key = CONTROL("b"),desc="goto symbol defination, Intellij idea",cmd = L.."vim.lsp.buf.definition()"},

    goto_next = {key = SPACE_S.."d.",cmd = L.."vim.diagnostic.goto_next()"},
    goto_prev = {key = SPACE_S.."d,",cmd = L.."vim.diagnostic.goto_prev()"},
    rename = {key = SPACE_S.."rr",cmd = L.."vim.lsp.buf.rename()",desc="rename"}, -- f2 key does the same -- 
    open_float = {key = LEADER_S.."vd",cmd=L.."vim.diagnostic.open_float()"},
    workspace_symbol = {key = nil,cmd=L.."vim.lsp.buf.workspace_symbol()"},
    hover = {key = SPACE_S.."fq",cmd=L.."vim.lsp.buf.hover()",desc = "find symbol information (hover)"},
    references = {key=SPACE_S.."fr",cmd = L.."vim.lsp.buf.references()",desc="find references"},
}

defaults.dap = {
    breakpoint = {key = SPACE_S.."db",cmd = C.."DapToggleBreakpoint",desc="debug toggle breakpoint"},
    continue = {key = SPACE_S.."dc",cmd = C.."DapContinue",desc="debug continue"},
}

defaults.undotree = {
    toggle = {key = ALT("5"),cmd=C.."UndotreeToggle",desc="undo tree toggle"}
}

defaults.conform = {
    format = { key = SPACE_S.."kf", cmd=L.."vim.lsp.buf.format()", desc="document format" },
}

defaults.symbols_outline = {
    toggle = {key = ALT("7"),cmd=C.."SymbolsOutline",desc="symbols outline"}
}

defaults.tabs = {
    go_left = {key = ALT(LEFT_ARROW),cmd = C.."BufferPrevious",desc="tab previous"},
    go_right = {key = ALT(RIGHT_ARROW),cmd = C.."BufferNext",desc = "tab next"},

    move_left = {key = ALT(DOWN_ARROW),cmd = C.."BufferMovePrevious",desc="tab move previous"},
    move_right = {key = ALT(UP_ARROW),cmd = C.."BufferMoveNext",desc="tab move next"},
    close = {key = ALT("x"),cmd = C.."BufferClose",desc="tab close"}
}

local metadata = nil
local keymaps = nil

if preferences.conf.save_config then
    metadata = file_data.create({file_name = "keymaps.json"})

    if not metadata then return error "Could not create metadata for keymaps" end

    local file_content = file.read_all_file(metadata.path)
    keymaps = not file_content and defaults or JSON.decode(file_content)
else
    keymaps = defaults
end

-- keymaps.file_explorer.toggle = {key = SPACE_S.."fm",cmd=preferences.editor.file_explorer.name == "netrw" and C.."Ex" or C.."Oil",desc = "file manager"}

setmetatable(keymaps,{__index = function(self,key)
	if key == "__metadata__" then
		return metadata or {}
    elseif key == "__cmd_types__" then
        return cmd_types
	end

    return rawget(self,key)
end})

if preferences.conf.validate_config then
    coroutine.resume(coroutine.create(function()
        table_e.validate_config_table(defaults,keymaps,{},{"desc"})
    end))
end

cmd_types.VCP = C
cmd_types.LCP = L
cmd_types.ECP = E

return keymaps
