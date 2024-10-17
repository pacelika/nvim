local M = {}

local strings = require("helper.utils.strings")
local file = require("helper.file")

local plugin_settings = require("plugin_settings")
local preferences = require("preferences")

if not preferences then
	return error("failed to fetch preferences module in load_plugins.lua")
end

if not plugin_settings then
	return error("failed to fetch plugin_settings module in load_plugins.lua")
end

local keymaps = require("keymaps")

local deferred_items = {}

local function _init_plugins()
	local is_ok
	local mod

	local is_table
	local is_enabled
	local defer
	local path
	local is_multi_path

	local function setup_mod(filename)
		is_ok, mod = pcall(require, filename)

		if is_ok and type(mod) == "table" and mod.setup then
			mod.setup()
		end
	end

	local function require_mod(filename)
		if type(filename) ~= "string" then
			print("Something went wrong:", filename, "is not a string")
			return
		end

		setup_mod(filename)

		if not is_ok then
			print(string.format("Could not load module: %s", filename))
			if mod then
				print(string.format("core.load_plugins, could not load module error: %s", mod))
			end
			setup_mod("plugin_config." .. filename)
		end
	end

	local function require_sub_mods(p_path)
		if type(p_path) == "string" then
			return require_mod(p_path)
		end
		for _, file_name in pairs(p_path) do
			require_mod(file_name)
		end
	end

	local function load_mod(data)
		is_table = type(data) == "table"
		is_enabled = is_table and data.enabled or not is_table and data

		if not is_enabled then
			return
		end
		path = (is_table and (data.module or data.modules))
		if not path then
			return
		end

		defer = is_table and data.defer and data.defer * 1000 or 0
		is_multi_path = type(path) == "table"

		if is_multi_path and is_table then
			if defer > 0 then
				if type(path) == "table" then
					for _, path_v in pairs(path) do
						table.insert(deferred_items, { path = path_v, defer = defer })
					end
				end
			else
				require_sub_mods(path)
			end
		elseif not is_multi_path and is_table then
			if defer > 0 then
				table.insert(deferred_items, { path = path, defer = defer, is_multi = false })
			else
				require_mod(path)
			end
		end
	end

    local preferred_plugins = {}

    if preferences.conf.template == "minimal" then
        preferred_plugins.lsp = plugin_settings.lsp
    else
        preferred_plugins = plugin_settings
    end

	for _, obj in pairs(preferred_plugins) do
		load_mod(obj)
	end

	for index, element in ipairs(deferred_items) do
		vim.defer_fn(function()
			require_mod(element.path)
			table.remove(deferred_items, index)
		end, element.defer)
	end
end

local function _use_plugins()
	local function init()
        require("plugins")
		xpcall(_init_plugins,error)
	end

	local success,err = pcall(init)

	if not success and err then
		print(("Error with 'use_plugins': %s"):format(err))
	end
end

local function write_config_file(data)
	local metadata = data.__metadata__

	if not file.file_exists(metadata.path) or metadata.out_of_date then
		local out_of_date_prev = metadata.out_of_date

		if file.write_file(metadata.path,strings.table_to_json_string(data)) then
			if out_of_date_prev then
				print(("INFO: %s was updated"):format(metadata.file_name))
			else
				print(("INFO: Generated %s"):format(metadata.file_name))
			end
		end
	end
end

function M.setup()
	_use_plugins()

	if preferences.conf.save_config_to_json then
		if not file.isdir(plugin_settings.__metadata__.folder_path) then
			file.mkdir(plugin_settings.__metadata__.folder_path)
		end

		write_config_file(plugin_settings)
		write_config_file(preferences)
		write_config_file(keymaps)

        if preferences.conf.template ~= "minimal" then
            vim.defer_fn(function()
                if not preferences.git.gitblame_inline then
                    pcall(vim.cmd.GitBlameDisable)
                end
            end,500)
        end
	end

	if not vim.v.argv[3] then
		local success, persistance = pcall(require, "persistence")

		if success and persistance then
			pcall(persistance.load)
		end
	end
end

return M