local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = {
    Act = ReplicatedStorage.Events.Match.Act,
    Acted = ReplicatedStorage.Events.Match.Acted,
    Timer = ReplicatedStorage.Events.Match.Timer,
}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

function disableButtons()
    for _, button in PlayerGui.ScreenGui.Buttons:GetChildren() do
        button.Visible = false
        button.Active = false
        button.Interactable = false
    end
end

function enableButtons()
    for _, button in PlayerGui.ScreenGui.Buttons:GetChildren() do
        button.Visible = true
        button.Active = true
        button.Interactable = true
    end
end

local Buttons = {}
for _, button in PlayerGui.ScreenGui.Buttons:GetChildren() do Buttons[button.Name] = button end
disableButtons()

Buttons.Left.MouseButton1Click:Connect(function()
    Events.Act:FireServer({Type = "CHECK"})
end)

Buttons.Middle.MouseButton1Click:Connect(function()
    -- NOTE: should be ALL IN
    Events.Act:FireServer({Type = "CALL" })
end)

Buttons.Right.MouseButton1Click:Connect(function()
    Events.Act:FireServer({Type = "BET", Amount = 100})
end)

Events.Act.OnClientEvent:Connect(function()
    enableButtons()
end)

Events.Acted.OnClientEvent:Connect(function()
    disableButtons()
end)
