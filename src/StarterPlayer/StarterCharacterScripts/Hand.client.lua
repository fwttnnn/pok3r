local CARDTEST: Part = workspace:WaitForChild("CARDTEST")

function f(handle, totalCards, radius, cardSpacing)
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


local Character = script.Parent

-- Load animation
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://81339895417526"
-- animation.AnimationId = "rbxassetid://95189410089661"

-- animation.Priority = Enum.AnimationPriority.Action4

local Humanoid = Character:WaitForChild("Humanoid")
local Animator = Humanoid:WaitForChild("Animator")

local anim = Animator:LoadAnimation(animation)


local player = game.Players.LocalPlayer
local cardGUI = player.PlayerGui.ScreenGui.ViewportFrame
cardGUI.Visible = false

Character.ChildAdded:Connect(function(child)
    if not child:IsA("Tool") then return end

    anim:Play()

    local tool: Tool = child
    local RightArm = Character:FindFirstChild("Right Arm")

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Parent = RightArm
    handle.Size = Vector3.new(0.5, 0.5, 0.5)
    handle.Anchored = false
    handle.CanCollide = false
    handle.Massless = true
    handle.Transparency = 1
    -- Instance.new("Highlight", handle)

    f(handle, math.random(2, 2), 1, 0.19)
    print(handle)

    local RightArmMotor6D = Instance.new("Motor6D")
    RightArmMotor6D.Name = "Right Arm Motor6D"
    RightArmMotor6D.Parent = RightArm
    RightArmMotor6D.Part0 = RightArm
    RightArmMotor6D.Part1 = handle

    RightArmMotor6D.C0 = 
        CFrame.new(-0.5, -0.6, 0.01) *
        CFrame.fromOrientation(
            -- -35, -65, 75
            -- -30, -60, 65
            math.rad(-30),
            math.rad(-60),
            math.rad(65)
        )
    
    cardGUI.Visible = true
end)

Character.ChildRemoved:Connect(function(child)
    if not child:IsA("Tool") then return end

    local tool: Tool = child
    local RightArm = Character:FindFirstChild("Right Arm")

    RightArm:FindFirstChild("Handle"):Destroy()
    RightArm:FindFirstChild("Right Arm Motor6D"):Destroy()

    anim:Stop()
    cardGUI.Visible = false
end)

local handCenter1 = workspace:WaitForChild("HANDCARDCENTER1")
local handCenter2 = workspace:WaitForChild("HANDCARDCENTER2")
f(handCenter1, 4, 1, 0.19)
