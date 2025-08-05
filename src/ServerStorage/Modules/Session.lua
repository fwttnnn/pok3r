--!strict
local Session = {}
Session.__index = Session

local ServerStorage = game:GetService("ServerStorage")
local Modules = ServerStorage:WaitForChild("Modules")

local Deck = require(Modules.Deck)
local Card = require(Modules.Card)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Objects = ReplicatedStorage:WaitForChild("Objects")

local Cards = Objects.Cards

function Session.new(players: {[number]: Player})
    local _players: {[number]: {Player: Player, Hand: {[number]: Card}}} = {}
    for _, player in ipairs(players) do
        _players[player.UserId] = {
            Player = player,
            Hand = {},
        }
    end

    local deck: Deck = Deck.new()
    for _, suit: Folder in ipairs(Cards:GetChildren()) do
        for _, rank: Part in ipairs(suit:GetChildren()) do
            deck:Push(Card.new(rank.Name, suit.Name))
        end
    end
    deck:Shuffle()

    return setmetatable({
        Players = _players,
        Deck = deck
    }, Session)
end

function Session:IsPlayerInSession(player: Player): boolean
    return self.Players[player.UserId] ~= nil
end

function Session:GetPlayer(player: Player): {}
    return self.Players[player.UserId]
end

function Session:Deal(player: Player)
    if not self:IsPlayerInSession(player) then return end

    local _player = self.Players[player.UserId]
    table.insert(_player.Hand, self.Deck:Pop())
end

return Session
