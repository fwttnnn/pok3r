--!strict
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Modules = ServerStorage:WaitForChild("Modules")
local Card = require(Modules.Poker.Card)
local Pile = require(Modules.Poker.Pile)
local Table = require(Modules.Poker.Table)

local Managers = ServerStorage:WaitForChild("Managers")
local TableManager = require(Managers.Table)

Players.PlayerAdded:Connect(function(player)
    local _table = Table.new({player, {UserId = 666}})
    TableManager.Add(_table)

    -- _table.Cards.Community:Push(Card.new("9", "Hearts"))
    -- _table.Cards.Community:Push(Card.new("4", "Clubs"))
    -- _table.Cards.Community:Push(Card.new("J", "Hearts"))
    -- _table.Cards.Community:Push(Card.new("4", "Spades"))
    -- _table.Cards.Community:Push(Card.new("9", "Clubs"))

    local _player1 = _table:GetPlayer(player)
    _player1.Hand:Push(Card.new("K", "Hearts"))
    _player1.Hand:Push(Card.new("4", "Hearts"))

    local _player2 = _table:GetPlayer({ UserId = 666 })
    _player2.Hand:Push(Card.new("A", "Hearts"))
    _player2.Hand:Push(Card.new("Q", "Clubs"))

    task.wait(1)
    _table:Deal()
    task.wait(1)
    _table:Deal()
    task.wait(1)
    _table:Deal()
    task.wait(1)
    _table:Deal()
    task.wait(1)
    _table:Deal()

    print(Pile.new(_player1.Hand:Highest(_table.Cards.Community.Cards)):Rank())
    print(Pile.new(_player2.Hand:Highest(_table.Cards.Community.Cards)):Rank())
end)
