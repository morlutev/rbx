local TableUtil = {}

function TableUtil.getPathValue(data: table, path: string)
    local indexes = string.split(path, "/")
    while #indexes > 1 do
        local index = indexes[1]
        table.remove(indexes, 1)
        data = data[index]
        if not data then
            return data
        end
    end
    return data[indexes[1]]
end

function TableUtil.setPathValue(data: table, path: string, value: any)
    local indexes = string.split(path, "/")
    while #indexes > 1 do
        local index = indexes[1]
        table.remove(indexes, 1)
        if not data[index] then
            data[index] = {}
        end
        data = data[index]
    end
    data[indexes[1]] = value
    return
end

function TableUtil.copy(template: table)
    if typeof(template) ~= "table" then return template end
    local new = {}

    for index, value in template do
        new[index] = TableUtil.copy(value)
    end

    return new
end

return TableUtil