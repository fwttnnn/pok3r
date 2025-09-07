--!strict
-- Match Manager, keep track of all the matchs (local server scope)
local Manager = {}

function Manager.Find(player: Player): Match
    for _, match in ipairs(Manager) do
        local p = match.Table:GetPlayer(player)
        if not p then continue end

        return match
    end

    return nil
end

function Manager.Add(match: Match)
    table.insert(Manager, match)
end

function Manager.Remove(match: Match)
    table.remove(Manager, table.find(Manager, match))
end

return Manager
