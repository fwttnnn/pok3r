--!strict
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Storages = {
    Global = {
        House = require(ServerStorage:WaitForChild("Storages").Global.House),
    },
}

Players.PlayerAdded:Connect(function(player: Player)
    player.CharacterAdded:Connect(function(character: Model)
        local head: Head = character:WaitForChild("Head")
        local humanoid: Humanoid = character:WaitForChild("Humanoid")

        -- NOTE: remove default display name
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

        -- local billboard = Instance.new("Part", head)
        -- billboard.Name = "Billboard"
        -- billboard.Size = Vector3.new(3, 1, 0.001)
        -- billboard.Anchored = true
        -- billboard.Massless = true
        -- billboard.CanCollide = false
        -- billboard.Transparency = 1
        -- billboard:SetAttribute("Billboard", true)
        -- billboard:SetAttribute("Attached", true)
        -- billboard:SetAttribute("Offset", Vector3.new(0, 1.8, 0))

        -- local gui = Instance.new("SurfaceGui", billboard)
        -- gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        -- gui.PixelsPerStud = 100
        -- gui.Face = Enum.NormalId.Back

        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(3, 0, 1.5, 0)
        billboard.StudsOffsetWorldSpace = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = false
        billboard.Name = "Billboard"
        billboard.Adornee = head
        billboard.Parent = head

        print(billboard)

        local frame = Instance.new("Frame", billboard)
        frame.Size = UDim2.fromScale(1, 1)
        frame.BackgroundTransparency = 1

        local layout = Instance.new("UIListLayout", frame)
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.HorizontalFlex = Enum.UIFlexAlignment.Fill
        -- layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)

        local wrapper = Instance.new("Frame", frame)
        wrapper.Name = "Wrapper"
        wrapper.BackgroundTransparency = 1
        wrapper.Size = UDim2.fromScale(1, .25)

        local layout = layout:Clone()
        layout.Parent = wrapper

        local nametag = Instance.new("TextLabel", frame)
        nametag.Name = "Nametag"
        nametag.Size = UDim2.fromScale(1, .5)
        nametag.BackgroundTransparency = 1
        nametag.Text = player.DisplayName

        local house = Storages.Global.House.Get(player)
        if house then
            nametag.Text = "[" .. house.Symbol .. "] " .. nametag.Text
        end

        nametag.TextColor3 = Color3.fromRGB(255, 255, 255)
        nametag.TextStrokeTransparency = .3
        nametag.Font = Enum.Font.GothamBold
        nametag.TextScaled = true
    end)
end)
