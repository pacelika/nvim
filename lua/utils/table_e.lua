local M = {}

function M.deepcopy(o, seen)
    seen = seen or {}
    if o == nil then return end
    if seen[o] then return seen[o] end

    local no

    if type(o) == 'table' then
        no = {}
        seen[o] = no

        for k, v in next, o, nil do
          no[exports.deepcopy(k, seen)] = exports.deepcopy(v, seen)
        end
        setmetatable(no, exports.deepcopy(getmetatable(o), seen))
    else -- number, string, boolean, etc
        no = o
    end

    return no
end

function find_value_in_t(t,what)
    for _,value in ipairs(t) do
        if value == what then
            return what
        end
    end
end

function M.validate_config_table(original_t,current_t,exceptions_t,inclusion_t,check_datatype)
    for name,data_t in pairs(original_t) do
        if current_t[name] == nil and original_t[name] then
            current_t.__metadata__.out_of_date = true
            current_t[name] = data_t
        end

        if type(data_t) == "table" then
            for opt,default_value in pairs(data_t) do
                if current_t[name][opt] == nil then
                    current_t.__metadata__.out_of_date = true
                    current_t[name][opt] = default_value
                end
            end
        end
    end

    for name, data_t in pairs(current_t) do
        if original_t[name] == nil then
            current_t[name] = nil
            current.__metadata__.out_of_date = true
        end

        if type(data_t) ~= "table" then 
            return error("data_t is not a table")
        end

        for opt,value in pairs(data_t) do

           if original_t[name][opt] == nil and not find_value_in_t(exceptions_t,opt) then
                current_t[name][opt] = nil   	 
                current_t.__metadata__.out_of_date = true
           end

            if not find_value_in_t(exceptions_t,opt) and type(value) ~= type(original_t[name][opt]) and check_datatype then
                print(string.format("%s::%s is not the same type as reference table.",name,opt,name))
            end
            
            -- if original_t[name][opt] then
            --     for _, included_key in ipairs(inclusion_t) do
            --         if current_t[name][opt][included_key] ~= data_t[included_key] then
            --            current_t[name][opt][included_key] = original_t[name][opt][included_key]   
            --            current_t.__metadata__.out_of_date = true
            --         end
            --     end
            -- end

            if current_t[name][opt] and find_value_in_t(inclusion_t,opt) then
                if value ~= original_t[name][opt] then
                    current_t[name][opt] = original[name][opt]
                    current_t.__metadata__.out_of_date = true
                end
            elseif current_t[name][opt] and type(opt) == "table" and find_value_in_t(inclusion_t,opt) then
                for _name, _value in pairs(type(value) == "table" and value or {}) do
                    if original_t[name][opt][_name] ~= _value then
                        current_t[name][opt][_name] = original_t[name][opt][_name]
                        current_t.__metadata__.out_of_date = true
                    end
                end
            end
        end -- data_t end --
    end -- current_t end --
end

return M
