--!strict
local Hand = {}
Hand.__index = Hand

function Hand.new()
    return setmetatable({
        Cards = {}
    }, Hand)
end

function Hand:Push(card: Card)
    table.insert(self.Cards, card)
end

function Hand:Pop(): Card
    return table.remove(self.Cards)
end

-- NOTE: this function does not hard copy the cards.
function Hand:Copy(): Hand
    local hand = Hand.new()

	for _, card in ipairs(self.Cards) do
        hand:Push(card)
	end

	return hand
end

function Hand:Sort(ace: number?)
    assert(not ace or ace == 1 or ace == 14)

    table.sort(self.Cards, function(a, b)
        -- NOTE: descending (high to low)
        return a:RankNumerical(ace) > b:RankNumerical(ace)
    end)
end

function Hand:__RankedNOfAKind(n: number): boolean
    local counts = {}
    for _, card in ipairs(self.Cards) do
        counts[card.Rank] = (counts[card.Rank] or 0) + 1
    end

    for _, count in pairs(counts) do
        if count == n then
            return true
        end
    end

    return false
end

function Hand:_RankedRoyalFlush(): boolean
    if self.Cards[1].Rank ~= "A" or self.Cards[2].Rank ~= "K" then
        return false
    end

    return self:_RankedStraight() and self:_RankedFlush()
end

function Hand:_RankedStraightFlush(ace: number?): boolean
    assert(not ace or ace == 1 or ace == 14)
    return self:_RankedStraight(ace) and self:_RankedFlush()
end

function Hand:_RankedFourOfAKind(): boolean
    return self:__RankedNOfAKind(4)
end

function Hand:_RankedFullHouse(): boolean
    local counts = {}
    for _, card in ipairs(self.Cards) do
        counts[card.Rank] = (counts[card.Rank] or 0) + 1
    end

    local hasThreeOfAKind = false
    local hasOnePair = false
    for _, count in pairs(counts) do
        if count == 3 then
            hasThreeOfAKind = true
        elseif count == 2 then
            hasOnePair = true
        end
    end

    return hasThreeOfAKind and hasOnePair
end

function Hand:_RankedFlush(): boolean
    local suit: string = self.Cards[1].Suit

    for _, card in ipairs(self.Cards) do
        if card.Suit ~= suit then
            return false
        end
    end

    return true
end

function Hand:_RankedStraight(ace: number?): boolean
    assert(not ace or ace == 1 or ace == 14)

    -- Not enough cards to form a straight
    if #self.Cards < 2 then
        return false
    end

    local prevRank = self.Cards[1]:RankNumerical()

    for i = 2, #self.Cards do
        local card = self.Cards[i]
        local currentRank = card:RankNumerical()

        if currentRank ~= prevRank + 1 then
            return false
        end

        prevRank = currentRank
    end

    return true
end

function Hand:_RankedThreeOfAKind(): boolean
    return self:__RankedNOfAKind(3)
end

function Hand:_RankedTwoPair(): boolean
    local counts = {}
    for _, card in ipairs(self.Cards) do
        counts[card.Rank] = (counts[card.Rank] or 0) + 1
    end

    local pairCount = 0
    for _, count in pairs(counts) do
        if count == 2 then
            pairCount += 1
        end
    end

    return pairCount == 2
end

function Hand:_RankedOnePair(): boolean
    return self:__RankedNOfAKind(2)
end

function Hand:_RankedHighCard(): boolean
    -- WARNING: this function is not gonna be used.
    assert(false)
    return false
end

function Hand:Rank(): number
    -- TODO: RETURN THE VALUE OF RANKED HAND (FROM _RANKED* FN), IN CASE A PLAYER HAVE THE SAME RANK.
    -- NOTE: must be sorted, and hand size must be 5.
    assert(#self.Cards == 5, "Hand must have exactly 5 cards")

    local handAce1  = self:Copy()
    local handAce14 = self:Copy()

    handAce1:Sort(1)
    handAce14:Sort(14)

    if handAce14:_RankedRoyalFlush()      then return 10 end
    if handAce14:_RankedStraightFlush(14) then return 9 end
    if handAce1:_RankedStraightFlush(1)   then return 9 end
    if handAce14:_RankedFourOfAKind()     then return 8 end
    if handAce14:_RankedFullHouse()       then return 7 end
    if handAce14:_RankedFlush()           then return 6 end
    if handAce14:_RankedStraight(14)      then return 5 end
    if handAce1:_RankedStraight(1)        then return 5 end
    if handAce14:_RankedThreeOfAKind()    then return 4 end
    if handAce14:_RankedTwoPair()         then return 3 end
    if handAce14:_RankedOnePair()         then return 2 end

    -- NOTE: ranked high card
    return 1
end

return Hand
