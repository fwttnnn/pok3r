--!strict
local Table = {}
Table.__index = Table

function Table.new()
    return setmetatable({}, Table)
end

return Table
