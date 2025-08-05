local ReplicatedStorage = game:GetService("ReplicatedStorage")

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local equipAnimation = animator:LoadAnimation(ReplicatedStorage.Animations.Card:FindFirstChild("Equip"))

local player = game.Players.LocalPlayer
local cardGUI = player.PlayerGui.ScreenGui.ViewportFrame
cardGUI.Visible = false

local EquipEvent = ReplicatedStorage.Events.Card:FindFirstChild("Equip")
local UnequipEvent = ReplicatedStorage.Events.Card:FindFirstChild("Unequip")

character.ChildAdded:Connect(function(child)
    if not child:IsA("Tool") then return end

    equipAnimation:Play()

    local tool: Tool = child
    EquipEvent:FireServer()

    cardGUI.Visible = true
end)

character.ChildRemoved:Connect(function(child)
    if not child:IsA("Tool") then return end

    equipAnimation:Stop()

    local tool: Tool = child
    UnequipEvent:FireServer()

    cardGUI.Visible = false
end)
