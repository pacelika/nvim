local plugin_settings = nil
local table_e = require "helper.table_e"

local file = require "helper.file"
local file_data = require "helper.file_data"
local preferences = require "preferences"
local JSON = require("helper.json")

if not preferences then return error "Failed to fetch prefernces in plugin_settings.lua" end

local defaults = {
    telescope = {
        enabled = true,
        modules = {builtin = "telescope.builtin",config = "plugin_conf.telescope"}
    },

    git = {
        enabled = true,
        modules = {gitsigns = "gitsigns",gitcore = "plugin_conf.git"},
    },

    which_key = {
        enabled = false,
        module = "plugin_conf.which_key"
    },

    goto = {
        enabled = true,
        module = "goto-preview"
    },

    dap = {
        enabled = true,
        module = "plugin_conf.dap"
    },

    numb = {
        enabled = true,
        module = "plugin_conf.numb"
    },

    ufo = {
        enabled = true,
        module = "plugin_conf.ufo"
    },

    undotree = {
        enabled = true,
    },

    noice = {
        enabled = true,
        module = "plugin_conf.noice",
    },

    refactoring = {
        enabled = true,
        module = "refactoring",
    },

    ibl = {
        enabled = true,
        module = "ibl",
    },

    colorizer = {
        enabled = true,
        module = "colorizer",
    },

    symbols_outline = {
        enabled = true,
        module = "symbols-outline",
    },

    illuminate = {
        enabled = true,
        module = "plugin_conf.illuminate",
    },

    status_line = {
        enabled = true,
        module = "plugin_conf.status_line",
    },

    tree_sitter = {
        enabled = true,
        module = "plugin_conf.treesitter",
    },

    webdev_icons = {
        enabled = true,
        module = "plugin_conf.webdev_icons"
    },

    treesj = {
        enabled = true,
    },

    alpha = {
       enabled = false,
       module = "plugin_conf.alpha",
    },

    conform = {
        enabled = true,
        module = "plugin_conf.conform"
    },

    nvim_tree = {
        enabled = true,
        module = "plugin_conf.nvim_tree",
    },

    discord = {
        enabled = false,
        module = "plugin_conf.discord_presence",
    },

    godot = {
        enabled = false,
        module = "plugin_conf.godot"
    },

    trouble = {
        enabled = false,
        module = "trouble",
    },

    terminal = {
        enabled = true,
        module = "plugin_conf.toggleterm",
    },

    tabs = {
        enabled = true,
        module = "plugin_conf.barbar",
    },

    file_explorer = {
        enabled = true,
        module = "plugin_conf.oil"
    },

    lsp = {
        enabled = true,
        modules = {lsp = "plugin_conf.lsp",cmp = "plugin_conf.cmp"}
    },
}

local metadata = nil

if preferences.conf.save_config then
    metadata = file_data.create({file_name = "plugins.json"})
    if not metadata then return print "failed to create metadata in plugin_settings.lua" end
    local file_content = file.read_all_file(metadata.path)
    plugin_settings = not file_content and defaults or JSON.decode(file_content)
else
    plugin_settings = defaults
end

setmetatable(plugin_settings,{__index = function(self,key)
	if key == "__metadata__" then
		return metadata or {}
	end

    return rawget(self,key)
end})

do 
    local new_state = preferences.conf.template ~= "minimal"

    for key in pairs(plugin_settings) do
        if key ~= "lsp" and plugin_settings[key].enabled then
            plugin_settings[key].enabled = new_state
        end
    end
end

if not plugin_settings then
    print "Something went wrong in plugin_settings.lua"
    return defaults
end

if preferences.conf.validate_config then
    coroutine.resume(coroutine.create(function()
        -- table_e.validate_config_table(defaults,plugin_settings,{},{})
    end))
end

if preferences.conf.template == "minimal" then
    plugin_settings.lsp.module = "plugin_conf.lsp_minimal"
end

return plugin_settings
