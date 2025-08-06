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

local Rank = {}
for i = 2, 10 do
	Rank[tostring(i)] = i
end

Rank["J"] = 11
Rank["Q"] = 12
Rank["K"] = 13
Rank["A"] = 14 -- NOTE: this can be either 14 or 1, this value will always be 14.

function Card.new(rank: Rank, suit: Suit)
    assert(Rank[rank])
    assert(Suit[suit])

    -- TODO: CURRENTLY, HAND CAN COPY ITSELF, WHICH CLONES A NEW CARD PART.
    -- INSTEAD, IT SHOULDN'T CLONE A NEW CARD PART.
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

function Card:RankNumerical(ace: number?): number
    assert(not ace or ace == 1 or ace == Rank["A"])
    ace = ace or Rank["A"]

    if self.Rank == "A" then
        return ace
    end

    return Rank[self.Rank]
end

return Card
