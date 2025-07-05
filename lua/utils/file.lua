local exports = {}

function exports.read_all_file(path)
    if not path then return end

    local file = io.open(path, "rb")

    if not file then return end

    local content = file:read("*all")

    file:close()

    return content
end

function exports.get_config_path()
    local config_dir = os.getenv("LOCALAPPDATA")

    if not config_dir then
        config_dir = vim.fn.expand("~")

        if not config_dir then
            return print("ERROR: FAILED TO GET CONFIG DIR")
        end

        config_dir = config_dir .. "/.config"
    end

    local config_path = config_dir .. "/nvim"

    return config_path
end

function exports.file_exists(file)
    if not file then return end
    local ok, err, code = os.rename(file, file)

    if not ok then
        return code == 13
    end

    return ok, err
end

function exports.isdir(path)
    if not path then return end
    return exports.file_exists(path .. "/")
end

function exports.mkdir(dirname)
    if not dirname then return end
    os.execute("mkdir " .. dirname)
end

function exports.read_file_lines(path)
    if not path then return end

    local file = io.open(path, "rb")

    if not file then return nil end

    local lines = {}

    for line in io.lines(path) do
        local words = {}

        for word in line:gmatch("%w+") do
            table.insert(words, word)
        end

        table.insert(lines, words)
    end

    file:close()

    return lines;
end

function exports.write_file(path, content)
    if not content or not path then return end

    local file = io.open(path, "w")
    if not file then return print(string.format("Could not write file: %s does not exist", path)) end

    local status = file:write(content)
    file:close()

    return status
end

return exports
