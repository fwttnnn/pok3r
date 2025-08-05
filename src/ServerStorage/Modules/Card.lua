--!strict
local Card = {}
Card.__index = Card

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Objects = ReplicatedStorage:WaitForChild("Objects")
local Cards = Objects.Cards

local Suit = {
    Spades   = true,
    Hearts   = true,
    Diamonds = true,
    Clubs    = true
}

local Rank = { J = true, Q = true, K = true, A = true }
for i = 2, 10 do
	Rank[tostring(i)] = true
end

function Card.new(rank: Rank, suit: Suit)
    assert(Rank[rank])
    assert(Suit[suit])

    local template: Part = workspace:WaitForChild("Board").CARDEXAMPLE
    local part: Part = Cards[suit][rank]:Clone()

    part.CFrame = template.CFrame
    part.Parent = nil
    part.Name = "Card"

    return setmetatable({
        Part = part,
        Rank = rank,
        Suit = suit,
    }, Card)
end

return Card
