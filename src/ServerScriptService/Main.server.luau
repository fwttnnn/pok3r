--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _table = require(ReplicatedStorage.Modules.Extension.Table)

local Players = game:GetService("Players")

local ServerStorage = game:GetService("ServerStorage")
local Modules = ServerStorage:WaitForChild("Modules")

local Match = require(Modules.Match)
local Table = require(Modules.Poker.Table)
local Timer = require(Modules.Common.Timer)

local Storages = {
    Memory = {
        Matches = require(ServerStorage:WaitForChild("Storages").Memory.Matches),
        Players = require(ServerStorage:WaitForChild("Storages").Memory.Players),
    },
}

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        Storages.Memory.Players.Load(player, true)
    end)
end)

-- NOTE: COMMENT ON PROD
-- if true then return end

local tables: Folder = workspace.Development.Tables
for _, t in ipairs(tables:GetChildren()) do
    local board: Folder = t
    local seats: Folder = board.Seats
    local billboard: BillboardGui = t.Billboard

    local timer = Timer.new()
    local anims = {}
    local players = {}

    local match

    local function __BillboardSetVisible()
        billboard.Frame.Visible = true
    end

    local function __BillboardSetInvisible()
        billboard.Frame.Visible = false
    end

    local function __AddPlayerIcon(player: Player)
        local frame: Frame = ReplicatedStorage.Icon:Clone()
        local image: ImageLabel = frame.ImageLabel

        local _p = nil -- NOTE: this should be fine, idk..
        while not _p do _p = Storages.Memory.Players.Get(player) end

        local icon: string = _p.Icon
        image.Image = icon

        frame.Name = player.UserId
        frame.Parent = billboard.Frame
    end

    function __RemovePlayerIcon(player: Player)
        local frame: Frame = billboard.Frame:FindFirstChild(tostring(player.UserId))
        if not frame then return end

        frame:Destroy()
    end

    function __RemoveAllPlayersIcon()
        for _, p in ipairs(players) do
            __RemovePlayerIcon(p)
        end
    end

    Players.PlayerRemoving:Connect(function(player: Player)
        __RemovePlayerIcon(player)
        table.remove(players, _table.index(players, function(p) return p == player end))
        local empty = #players == 0

        if empty then
            if not match then
                __BillboardSetInvisible()
            end

            timer:Stop()
            timer:Reset()
        end
    end)

    timer.Progression.Timid:Connect(function(sec)
        if match then return end
        print("match starting in:", sec)
    end)

    timer.Finished:Connect(function()
        if match then return end
        if #players <= 1 then
            timer:Reset()
            timer:Start(5)
            return
        end

        __RemoveAllPlayersIcon()
        __BillboardSetInvisible()

        task.spawn(function()
            for _, p in ipairs(players) do
                Storages.Memory.Players.Load(p)
            end

            match = Match.new(players)
            Storages.Memory.Matches.Add(match)

            match:Start()
            Storages.Memory.Matches.Remove(match)

            -- NOTE: players that is already in the match disconnected,
            --       and there is no more player on the table to start a new game.
            if #match.Table.Players == 0 then
                match.Table:Destroy()
                match = nil
                return
            end

            -- NOTE: there's still players on the table,
            --       starting the game again, soon.
            match.Table:Destroy()
            match = nil

            __BillboardSetVisible()
            for _, p in ipairs(players) do
                __AddPlayerIcon(p)
            end

            timer:Reset()
            timer:Start(5)
        end)
    end)

    for _, model in ipairs(seats:GetChildren()) do
        local seat = model.Seat

        seat.ChildAdded:Connect(function(child)
            if child.ClassName ~= "Weld" then return end
            
            local humanoid = child.Part1.Parent:FindFirstChild("Humanoid")
            if not humanoid then return end

            local player = game.Players:GetPlayerFromCharacter(humanoid.Parent)
            if not player then return end

            local empty = #players == 0
            table.insert(players, player)

            if empty then
                timer:Stop()
                timer:Reset()
                timer:Start(5)
            end

            if not match then
                __BillboardSetVisible()
                __AddPlayerIcon(player)
            end

            local animator = humanoid:WaitForChild("Animator")
            anims[player.UserId] = animator:LoadAnimation(ReplicatedStorage.Animations.Sit:FindFirstChild("Lean"))
            anims[player.UserId]:Play()
        end)

        seat.ChildRemoved:Connect(function(child)
            if child.ClassName ~= "Weld" then return end

            local humanoid = child.Part1.Parent:FindFirstChild("Humanoid")
            if not humanoid then return end

            local player = game.Players:GetPlayerFromCharacter(humanoid.Parent)
            if not player then return end
            
            __RemovePlayerIcon(player)
            table.remove(players, _table.index(players, function(p) return p == player end))
            local empty = #players == 0

            if empty then
                if not match then
                    __BillboardSetInvisible()
                end

                timer:Stop()
                timer:Reset()
            end

            anims[player.UserId]:Stop()
            anims[player.UserId]:Remove()
            anims[player.UserId] = nil
        end)
    end
end
