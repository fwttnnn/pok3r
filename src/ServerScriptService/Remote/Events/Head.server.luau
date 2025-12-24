--!strict
-- CREDIT: https://www.youtube.com/watch?v=HjfjWySxRRA
local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events

Events.Head.Look.OnServerEvent:Connect(function(player, neckCFrame: CFrame)
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")

    for _, _p in pairs(game.Players:GetPlayers()) do
        if _p == player then continue end

        local otherChar = _p.Character or _p.CharacterAdded:Wait()
        local otherHead = otherChar:WaitForChild("Head")

        local distance = 10 -- studs
        if (otherHead.Position - head.Position).Magnitude >= distance then continue end

        Events.Head.Look:FireClient(_p, player, neckCFrame)
    end
end)
