--!strict
-- CREDIT: https://www.youtube.com/watch?v=YsBQX4TAupo
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Objects = ReplicatedStorage:WaitForChild("Objects")
local Sounds  = workspace.Invisible.SFX
-- local Sounds  = ReplicatedStorage:WaitForChild("Sounds")

local character = script.Parent
local range = {
    min = 0,
    max = 10, -- studs
}

-- NOTE: will get initiated on `RenderStepped`.
local __heart_size = nil

if true then return end

local function __normalize(value, min, max, newMin, newMax)
    if max == min then
        return newMin
    end

    local normalized = (value - min) / (max - min)
    if normalized < 0 then
        normalized = 0
    elseif normalized > 1 then
        normalized = 1
    end

    return normalized * (newMax - newMin) + newMin
end

RunService.RenderStepped:Connect(function(dt: number)
    local torso = character:WaitForChild("Torso")
    local heart = torso:FindFirstChild("Heart")

    if not heart then
        heart = Objects.Heart:Clone()
        heart.Parent = torso
        heart.Position = torso.Position + Vector3.new(0, 0.275, 0)
        
        local weld = Instance.new("WeldConstraint", torso)
        weld.Part0 = torso
        weld.Part1 = heart
    end

    -- NOTE: we need the original heart size
    if not __heart_size then __heart_size = heart.Size end

    -- TODO: other script should be able to change `threat` value
    local sound = Sounds.Heartbeat
    local threat = 1

    if threat > 0 and not sound.Playing then
        sound:Play()
    end

    if threat <= 0 then
        sound:Stop()
    end

    sound.Volume        = __normalize(range.max - threat, range.min, range.max, 0, 0.65)
	sound.PlaybackSpeed = __normalize(range.max - threat, range.min, range.max, 0.8, 2)

    TweenService:Create(heart:FindFirstChildWhichIsA("Highlight"),
                        TweenInfo.new(dt * 1.5, Enum.EasingStyle.Linear),
                        {FillTransparency    = __normalize(threat, range.min, range.max, 0, 1),
                         OutlineTransparency = __normalize(threat, range.min, range.max, 0, 1)})
                         :Play()

    local scale = math.clamp(sound.PlaybackLoudness / 275, 0, 0.2)
    heart.Size = __heart_size + Vector3.new(scale, scale, scale) 
end)
