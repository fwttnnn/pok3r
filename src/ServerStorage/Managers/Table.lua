--!strict
-- Table Manager, keep track of all the tables
local TableManager = {}

function TableManager.FindPlayerTable(player: Player): Table
    for _, _table in ipairs(TableManager) do
        if _table.Players[player.UserId] then
            return _table
        end
    end

    return nil
end

function TableManager.Add(_table: Table)
    table.insert(TableManager, _table)
end

return TableManager
