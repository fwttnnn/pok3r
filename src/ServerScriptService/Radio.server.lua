-- A radio that plays through all players.

-- burn 90935264615216

soundIds = {9119383684}
cursor = 1

sound = Instance.new("Sound")
sound.Name = "Background"
sound.Parent = workspace.Invisible.SFX

sound.SoundId = "rbxassetid://" .. soundIds[cursor]
sound:Play()

sound.Ended:Connect(function(_soundId)
    cursor = (cursor % #soundIds) + 1

    sound.SoundId = "rbxassetid://" .. soundIds[cursor]
    sound:Play()
end)
