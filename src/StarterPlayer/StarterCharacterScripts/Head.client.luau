--!strict
-- CREDIT: https://www.youtube.com/watch?v=HjfjWySxRRA
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = {
    Head = {
        Look = ReplicatedStorage.Events.Head.Look,
    },
}

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if RunService:IsStudio() then
    print("Development Mode: skipping heavy code")
    return
end

local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Neck = Character:FindFirstChild("Neck", true)

local otherPlayerNecks: {[Player]: CFrame} = {}

Players.PlayerRemoving:Connect(function(plr)
    otherPlayerNecks[plr] = nil
end)

RunService.RenderStepped:Connect(function()
    local yOffset = Neck.C0.Y
    local cameraDirection = HumanoidRootPart.CFrame:toObjectSpace(Camera.CFrame).lookVector

    local targetC0 = CFrame.new(0, yOffset, 0)
        * CFrame.Angles(3 * math.pi/2, 0, math.pi)
        * CFrame.Angles(0, 0, -math.asin(cameraDirection.x))
        * CFrame.Angles(-math.asin(cameraDirection.y), 0, 0)

    local alpha = .2
    Neck.C0 = Neck.C0:Lerp(targetC0, alpha)

    for otherPlayer, targetCFrame in pairs(otherPlayerNecks) do
        local char = otherPlayer.Character
        if not char then continue end

        local neck = char:FindFirstChild("Neck", true)
        if not neck then continue end

        local alpha = .35
        neck.C0 = neck.C0:Lerp(targetCFrame, alpha)
    end
end)

Events.Head.Look.OnClientEvent:Connect(function(otherPlayer: Player, neckCFrame: CFrame)
    otherPlayerNecks[otherPlayer] = neckCFrame
end)

task.spawn(function()
    while task.wait(.1) do
        Events.Head.Look:FireServer(Neck.C0)
    end
end)
