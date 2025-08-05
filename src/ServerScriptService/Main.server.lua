local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EquipEvent = ReplicatedStorage.Events.Card:FindFirstChild("Equip")
local UnequipEvent = ReplicatedStorage.Events.Card:FindFirstChild("Unequip")

local CARDTEST: Part = workspace:WaitForChild("CARDTEST")

function buildCards(handle, totalCards, radius, cardSpacing)
    local center = handle.Position

    local arcLength = cardSpacing * (totalCards - 1)
    local arcRadians = arcLength / radius
    local arcDegrees = math.deg(arcRadians)

    for i = 1, totalCards do
        local angleDeg = arcDegrees / 2 - (i - 1) * (arcDegrees / math.max(totalCards - 1, 1))
        local angleRad = math.rad(angleDeg)

        local card = CARDTEST:Clone()
        card.Anchored = false
        card.CanCollide = false
        card.Massless = true
        card.Parent = handle

        local offset = Vector3.new(
            math.sin(angleRad) * radius,
            0,
            math.cos(angleRad) * radius
        )

        local position = center - offset + Vector3.new(0, i * card.Size.Y, 0)
        card.Position = position
        card.CFrame = CFrame.lookAt(position, center) * CFrame.Angles(0, math.rad(180), 0)

        local weld = Instance.new("WeldConstraint")
        weld.Parent = card
        weld.Part0 = card
        weld.Part1 = handle
    end
end

EquipEvent.OnServerEvent:Connect(function(player: Player)
    local character = player.Character or player.CharacterAdded:Wait()
    local rightArm = character:FindFirstChild("Right Arm")

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Parent = rightArm
    handle.Size = Vector3.new(0.5, 0.5, 0.5)
    handle.Anchored = false
    handle.CanCollide = false
    handle.Massless = true
    handle.Transparency = 1
    Instance.new("Highlight", handle)

    buildCards(handle, math.random(2, 2), 1, 0.19)

    local rightArmMotor6D = Instance.new("Motor6D")
    rightArmMotor6D.Name = "Right Arm Motor6D"
    rightArmMotor6D.Parent = rightArm
    rightArmMotor6D.Part0 = rightArm
    rightArmMotor6D.Part1 = handle

    -- NOTE: magic number
    rightArmMotor6D.C0 = 
        CFrame.new(-0.5, -0.6, 0.01) *
        CFrame.fromOrientation(
            math.rad(-30),
            math.rad(-60),
            math.rad(65)
        )
end)


UnequipEvent.OnServerEvent:Connect(function(player: Player)
    local character = player.Character or player.CharacterAdded:Wait()
    local rightArm = character:FindFirstChild("Right Arm")

    rightArm:FindFirstChild("Handle"):Destroy()
    rightArm:FindFirstChild("Right Arm Motor6D"):Destroy()
end)
