--!strict
local Matchmaking = {
    Brackets = {
        Bronze = { Min = 0, Max = 999 },
        Silver = { Min = 1000, Max = 1499 },
    }
}

local MemoryStoreService = game:GetService("MemoryStoreService")
local TeleportService = game:GetService("TeleportService")

function Matchmaking.Queue(player: Player)
    -- TODO: get player's bracket info
    local bracket = "Bronze"
    assert(Matchmaking.Brackets[bracket])

    local queue = MemoryStoreService:GetQueue("Queue--" .. bracket)

    local success, err = pcall(function()
        local id = player.UserId
        queue:AddAsync(id, 60) -- NOTE: expires after 60 seconds
    end)

    if not success then return Matchmaking.Queue(player) end
end

function Matchmaking.Dequeue(player: Player)
    -- TODO: get player's bracket info
    local bracket = "Bronze"
    assert(Matchmaking.Brackets[bracket])

    local queue = MemoryStoreService:GetQueue("Queue--" .. bracket)

    local success, err = pcall(function()
        local id = player.UserId
        queue:RemoveAsync(id)
    end)

    if not success then return Matchmaking.Dequeue(player) end
end

function Matchmaking.Listen()
    for bracket in pairs(Matchmaking.Brackets) do
        local queue = MemoryStoreService:GetQueue("Queue--" .. bracket)
        local ids 

        local success, err = pcall(function()
            local n = 2
            local invisiblity = 3 -- make players invisible for x, in seconds
            ids = queue:ReadAsync(n, true, invisiblity)
        end)

        if not success or not ids then continue end

        local players = {}
        for _, id in ipairs(ids) do
            local p = game.Players:GetPlayerByUserId(id)
            if not p then -- NOTE: player disconnects
                pcall(function() queue:RemoveAsync(id) end) continue
            end

            table.insert(players, p)
        end

        if #players ~= #ids then continue end

        local placeId = 100523856012906
        local teleportOptions = Instance.new("TeleportOptions")
        teleportOptions.ShouldReserveServer = false -- TODO: check up docs

        local success, err = pcall(function()
            -- TODO: use Server Manager to find public server.
            TeleportService:TeleportAsync(placeId, players, teleportOptions)

            for _, player in ipairs(players) do
                queue:RemoveAsync(player.UserId)
            end
        end)
    end

    task.delay(1, Matchmaking.Listen) -- NOTE: avoid stack overflow, the caller should know this fn spawns new thread.
                                      -- although, would it make infinite threads? no cuz the thread is dismissed.
end

return Matchmaking
