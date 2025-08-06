local ReplicatedStorage = game:GetService("ReplicatedStorage")

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local equipAnimation = animator:LoadAnimation(ReplicatedStorage.Animations.Hand:FindFirstChild("Equip"))

local player = game.Players.LocalPlayer
local cardGUI = player.PlayerGui.ScreenGui.ViewportFrame
cardGUI.Visible = false

local EquipFunction = ReplicatedStorage.Functions.Hand:FindFirstChild("Equip")
local UnequipFunction = ReplicatedStorage.Functions.Hand:FindFirstChild("Unequip")

local Objects = ReplicatedStorage:WaitForChild("Objects")
local Cards = Objects.Cards.Poker

character.ChildAdded:Connect(function(child)
    if not child:IsA("Tool") then return end

    equipAnimation:Play()
    local cards = EquipFunction:InvokeServer()
    local rightArm = character:FindFirstChild("Right Arm")

    for i, card in ipairs(cards) do
        rightArm.Handle[i].Face.Texture = Cards[card.Suit][card.Rank].Face.Texture
    end

    cardGUI.Visible = true
end)

character.ChildRemoved:Connect(function(child)
    if not child:IsA("Tool") then return end

    equipAnimation:Stop()
    UnequipFunction:InvokeServer()

    cardGUI.Visible = false
end)
