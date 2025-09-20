--!strict
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Modules = ServerStorage:WaitForChild("Modules")
local Match = require(Modules.Match)

local Storages = {
    Memory = {
        Matches = require(ServerStorage:WaitForChild("Storages").Memory.Matches),
        Players = require(ServerStorage:WaitForChild("Storages").Memory.Players),
    },
}

local __players = {}
Players.PlayerAdded:Connect(function(player)
    table.insert(__players, player)

    -- NOTE: so that when player respawn, they would be re-loaded.
    player.CharacterAdded:Connect(function(character)
        Storages.Memory.Players.Load(player)
    end)
end)

-- NOTE: listen for players to join, for testing purposes.
task.spawn(function()
    while true do
        task.wait(0.5)
        if #__players < 2 then continue end
        task.wait(4)

        local p2 = table.remove(__players)
        local p1 = table.remove(__players)

        -- TODO: remove this, just wait for it to load on some script
        Storages.Memory.Players.Load(p1)
        Storages.Memory.Players.Load(p2)

        local match = Match.new({p1, p2})
        Storages.Memory.Matches.Add(match)
        match:Start()

        task.wait(3)
        match:Rematch()
    end
end)
