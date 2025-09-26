--!strict
--[[
    CREDIT: https://x.com/Onogork/status/1832638111014179267

    This script creates a part that is scaled to the player's viewport and adds a SurfaceGui
    that updates its PixelsPerStuds to match the scaling of a ScreenGui instance.

    SurfaceGuis are affected by the PostProcessing effects added under game.Lighting so more
    effects can be achieved!

    In this demo's case it tiles a paraboloid gradient to make the screen look lower resolution!
    I use it a few times, once to split up the screen, and other times to amplify some of the reds,
    greens, and blues.
--]]

if true then return end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local part = Instance.new("Part")
part.Parent = workspace
part.Transparency = 1
part.Anchored = true
part.CanCollide = false

local surfaceGui = ReplicatedStorage.Filters:FindFirstChild("VHS")
surfaceGui.Name = "WorldScreenGui"
surfaceGui.Face = "Back"
surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
surfaceGui.Adornee = part
surfaceGui.Parent = playerGui

local OFFSET_DISTANCE = 0.101

RunService:BindToRenderStep("CoverScreen", Enum.RenderPriority.Camera.Value + 1, function(d)
    local cam = workspace.CurrentCamera

    local viewportSize = cam.ViewportSize
    local height = math.tan(math.rad(cam.FieldOfView / 2)) * 2 * OFFSET_DISTANCE
    local width = (viewportSize.X / viewportSize.Y)	* height

    part.Size = Vector3.new(width, height, OFFSET_DISTANCE)
    part.CFrame = cam.CFrame * CFrame.new(0,0, -(OFFSET_DISTANCE + (part.Size.Z/2)))

    surfaceGui.PixelsPerStud = viewportSize.X / width	 
end)
