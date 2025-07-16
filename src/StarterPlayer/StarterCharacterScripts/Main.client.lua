local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Deck = require(ReplicatedStorage:WaitForChild("Deck"))
local Card = require(ReplicatedStorage:WaitForChild("Card"))

local deck = Deck.new()

for i = 1, deck.MAXSIZE do
    deck:push(Card.new())
end


deck:setTransparency(1)
print(deck)
