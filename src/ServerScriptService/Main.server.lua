--!strict
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Modules = ServerStorage:WaitForChild("Modules")
local Card = require(Modules.Card)
local Pile = require(Modules.Pile)
local Table = require(Modules.Table)

local Managers = ServerStorage:WaitForChild("Managers")
local TableManager = require(Managers.Table)

Players.PlayerAdded:Connect(function(player)
    local _table = Table.new({player, {UserId = 69}})
    TableManager.Add(_table)

    _table.Cards.Community:Push(Card.new("5", "Diamonds"))
    _table.Cards.Community:Push(Card.new("6", "Clubs"))
    _table.Cards.Community:Push(Card.new("6", "Spades"))
    _table.Cards.Community:Push(Card.new("2", "Diamonds"))
    _table.Cards.Community:Push(Card.new("A", "Clubs"))

    local _player = _table:Player(player)
    _player.Hand:Push(Card.new("5", "Spades"))
    _player.Hand:Push(Card.new("5", "Clubs"))

    print(Pile.new(_player.Hand:Highest(_table.Cards.Community.Cards)):Rank())
end)
