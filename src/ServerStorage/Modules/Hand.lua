--!strict
local Hand = {}
Hand.__index = Hand

function Hand.new(cards: Cards?)
    cards = cards or {}

    return setmetatable({
        Cards = cards
    }, Hand)
end

function Hand:Push(card: Card)
    table.insert(self.Cards, card)
end

function Hand:Pop(): Card
    return table.remove(self.Cards)
end

function Hand:ChangeAces(ace: number)
    assert(ace == 1 or ace == 14)

	for _, card in ipairs(self.Cards) do
        card.Ace = ace
	end
end

function Hand:Copy(): Hand
    local hand = Hand.new()

	for _, card in ipairs(self.Cards) do
        hand:Push(card:Copy())
	end

	return hand
end

function Hand:Sort()
    self:SortByRank()
end

function Hand:SortByRank()
    table.sort(self.Cards, function(a, b)
        -- NOTE: descending (high to low)
        return a:RankAsNumeric() > b:RankAsNumeric()
    end)
end

function Hand:SortBySuit()
    table.sort(self.Cards, function(a, b)
        if a.Suit == b.Suit then
            return a:RankAsNumeric() > b:RankAsNumeric()
        end

        return a.Suit < b.Suit
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

function Hand:_RankedStraightFlush(): boolean
    return self:_RankedStraight() and self:_RankedFlush()
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

function Hand:_RankedStraight(): boolean
    -- Not enough cards to form a straight
    if #self.Cards < 2 then
        return false
    end

    local prevRank = self.Cards[1]:RankAsNumeric()

    for i = 2, #self.Cards do
        local card = self.Cards[i]
        local currentRank = card:RankAsNumeric()

        -- NOTE: this assumes the cards are sorted in descending order
        if currentRank ~= prevRank - 1 then
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

function _slice(tbl, start, stop)
    assert(start <= stop and stop <= #tbl)
    local sliced = {}

    for i = start, stop do
        table.insert(sliced, tbl[i])
    end

    return sliced
end

function _combinations(tbl, n)
    assert(n >= 0 and n <= #tbl)
    local combinations = {}

    for i = 1, #tbl do
        if (i - 1) + n > #tbl then
            break
        end

        table.insert(combinations, _slice(tbl, i, (i - 1) + n))
    end

    return combinations
end

function Hand:Highest(cards: {Card}): {Card}
    local hand = self:Copy()
    for _, card in ipairs(cards) do
        hand:Push(card)
    end

    local handAces14SortedByRank = hand:Copy()
    local handAces14SortedBySuit = hand:Copy()
    local handAces1SortedByRank  = hand:Copy()
    local handAces1SortedBySuit  = hand:Copy()

    handAces14SortedByRank:ChangeAces(14)
    handAces14SortedBySuit:ChangeAces(14)
    handAces1SortedByRank:ChangeAces(1)
    handAces1SortedBySuit:ChangeAces(1)

    handAces14SortedByRank:SortByRank()
    handAces14SortedBySuit:SortBySuit()
    handAces1SortedByRank:SortByRank()
    handAces1SortedBySuit:SortBySuit()

    local function bestHand(combinations)
        local best = { hand = nil, score = 0 }

        for _, cards in ipairs(combinations) do
            -- TODO: THIS SUCKS, I ONLY NEED :RANK()
            -- BUT, I HAVE TO CREATE A WHOLE NEW OBJECT.
            local hand = Hand.new(cards)
            local score = hand:Rank()

            if score > best.score then
                best.hand = hand
                best.score = score
            end
        end

        return best
    end

    local handAces14SortedByRankBest = bestHand(_combinations(handAces14SortedByRank.Cards, 5))
    local handAces14SortedBySuitBest = bestHand(_combinations(handAces14SortedBySuit.Cards, 5))
    local handAces1SortedByRankBest  = bestHand(_combinations(handAces1SortedByRank.Cards, 5))
    local handAces1SortedBySuitBest  = bestHand(_combinations(handAces1SortedBySuit.Cards, 5))

    local best = handAces14SortedByRankBest

    for _, candidate in ipairs({
        handAces14SortedByRankBest,
        handAces14SortedBySuitBest,
        handAces1SortedByRankBest,
        handAces1SortedBySuitBest,
    }) do
        if candidate.score > best.score then
            best = candidate
        end
    end

    return best.hand.Cards
end

function Hand:Rank(): number
    -- TODO: RETURN THE VALUE OF RANKED HAND (FROM _RANKED* FN), IN CASE A PLAYER HAVE THE SAME RANK.
    -- NOTE: must be sorted, and hand size must be 5.
    assert(#self.Cards == 5, "Hand must have exactly 5 cards")

    if self:_RankedRoyalFlush()    then return 10 end
    if self:_RankedStraightFlush() then return 9 end
    if self:_RankedFourOfAKind()   then return 8 end
    if self:_RankedFullHouse()     then return 7 end
    if self:_RankedFlush()         then return 6 end
    if self:_RankedStraight()      then return 5 end
    if self:_RankedThreeOfAKind()  then return 4 end
    if self:_RankedTwoPair()       then return 3 end
    if self:_RankedOnePair()       then return 2 end
    return 1 -- NOTE: ranked high card
end

return Hand
