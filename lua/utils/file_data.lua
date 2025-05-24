local M = {}

local file = require "helper.file"

local folder_name = "settings"
local folder_path = file.get_config_loc() .. (file.is_win32() and "\\" .. folder_name or "/" .. folder_name)

function M.create(data)
    if not data.file_name then return error "file_name field is nil" end

    return {
        folder_name = data.folder_name or folder_name,
        folder_path = data.folder_path or folder_path,
        file_name = data.file_name,
        path = data.folder_path or folder_path .. "/" .. data.file_name
    }
end

return M
