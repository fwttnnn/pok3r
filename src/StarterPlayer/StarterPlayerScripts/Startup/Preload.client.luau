--!strict
-- this loads all the neccessary textures.

local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Objects = ReplicatedStorage:WaitForChild("Objects")
local Cards = Objects.Cards

local textures = {}
for _, suit: Folder in ipairs(Cards.Poker:GetChildren()) do
    for _, card: Part in ipairs(suit:GetChildren()) do
        table.insert(textures, card.Face.Texture)
    end
end
table.insert(textures, Cards.Blank.Decal)

ContentProvider:PreloadAsync(textures)
