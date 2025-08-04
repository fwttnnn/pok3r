local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Deck = require(ReplicatedStorage:WaitForChild("Deck"))
local Card = require(ReplicatedStorage:WaitForChild("Card"))

local deck = Deck.new()

for i = 1, deck.MAXSIZE do
    deck:Push(Card.new())
end

local CARDLINE1 = workspace:WaitForChild("Board").CARDLINE1
local CARDLINE2 = workspace:WaitForChild("Board").CARDLINE2

task.wait(1.2)

deck:Deal(nil, CARDLINE1.Position, 0)
task.wait(0.5)
deck:Deal(nil, CARDLINE1.Position, 1)

task.wait(1.2)

deck:Deal(nil, CARDLINE2.Position, 0)
task.wait(0.5)
deck:Deal(nil, CARDLINE2.Position, 1)
