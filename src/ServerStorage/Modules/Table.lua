--!strict
local Table = {}
Table.__index = Table

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Objects = ReplicatedStorage:WaitForChild("Objects")
local Cards = Objects.Cards.Poker

local ServerStorage = game:GetService("ServerStorage")
local Modules = ServerStorage:WaitForChild("Modules")

local Deck = require(Modules.Deck)
local Card = require(Modules.Card)
local Pile = require(Modules.Pile)

function Table.new(players: {[number]: Player})
    local _players: {[number]: {Player: Player, Hand: Hand}} = {}
    for _, player in ipairs(players) do
        _players[player.UserId] = {
            Player = player,
            Hand = Pile.new(), 
        }
    end

    local deck = Deck.new()
    for _, suit: Folder in ipairs(Cards:GetChildren()) do
        for _, rank: Part in ipairs(suit:GetChildren()) do
            deck:Push(Card.new(rank.Name, suit.Name))
        end
    end
    deck:Shuffle()

    return setmetatable({
        Players = _players,
        Deck = deck,
        Cards = {
            Community = Pile.new(),
            Burned = Pile.new()
        }
    }, Table)
end

function Table:Player(player: Player)
    return self.Players[player.UserId]
end

function Table:Deal(player: Player)
    if not self:Player(player) then return end

    local _player = self:Player(player)
    _player.Hand:Push(self.Deck:Pop())
end

return Table
