--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Objects = ReplicatedStorage:WaitForChild("Objects")
local Cards = Objects.Cards.Poker

local TweenService = game:GetService("TweenService")

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local equipAnimation = animator:LoadAnimation(ReplicatedStorage.Animations.Hand:FindFirstChild("Equip"))

local player = game.Players.LocalPlayer
local cardGUI = player.PlayerGui.ScreenGui.Cards

-- NOTE: eh, wtf..
local __play_gui_cards = false

local Functions = {
    Equip = ReplicatedStorage.Functions.Hand.Equip,
    Unequip = ReplicatedStorage.Functions.Hand.Unequip,
}

character.ChildAdded:Connect(function(child)
    if not child:IsA("Tool") then return end

    equipAnimation:Play()
    local cards = Functions.Equip:InvokeServer()
    local rightArm = character:FindFirstChild("Right Arm")

    for i, card in ipairs(cards) do
        rightArm.Handle:WaitForChild(tostring(i)).Face.Texture = Cards[card.Suit][card.Rank].Face.Texture

        local part = Cards[card.Suit][card.Rank]:Clone()
        part.Name = "Card"
        part.Parent = cardGUI

        part.Size = Vector3.new(.95, part.Size.Y, 1.1)

        local cardSpacing = part.Size.X + .1
        local totalCards = #cards
        local middleOffset = (totalCards - 1) * cardSpacing / 2

        local xOffset = (i - 1) * cardSpacing - middleOffset

        part.Position = Vector3.new(xOffset, 0, 0)
        part.Orientation = Vector3.new(-90, 180, 0)

        task.spawn(function()
            __play_gui_cards = true

            local originalPosition = part.Position
            local originalRotation = part.Rotation

            local function tweenCard(sec: number, position: Vector3, rotation: Vector3, easing: EasingStyle)
                local goal = {}
                goal.Position = originalPosition + position
                goal.Rotation = originalRotation + rotation

                return TweenService:Create(part, TweenInfo.new(sec, easing, Enum.EasingDirection.InOut), goal)
            end

            local idle1 = tweenCard(2, Vector3.new(0, 0.05, 0), Vector3.new(-10, 0, 10), Enum.EasingStyle.Sine)
            local idle2 = tweenCard(3, Vector3.new(0, -0.05, 0), Vector3.new(-10, 0, -10), Enum.EasingStyle.Exponential)

            while __play_gui_cards do
                idle1:Play()
                idle1.Completed:Wait()

                idle2:Play()
                idle2.Completed:Wait()
            end
        end)
    end

    cardGUI.Visible = true
end)

character.ChildRemoved:Connect(function(child)
    if not child:IsA("Tool") then return end

    equipAnimation:Stop()
    Functions.Unequip:InvokeServer()

    cardGUI.Visible = false
    __play_gui_cards = false

    for _, part: Part in ipairs(cardGUI:GetChildren()) do
        if part.Name ~= "Card" then continue end
        part:Destroy()
    end
end)
