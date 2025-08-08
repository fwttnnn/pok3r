--!strict
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Modules = ServerStorage:WaitForChild("Modules")
local Card = require(Modules.Card)
local Table = require(Modules.Table)

local Managers = ServerStorage:WaitForChild("Managers")
local TableManager = require(Managers.Table)

Players.PlayerAdded:Connect(function(player)
    local _table = Table.new({player, {UserId = 69}})
    TableManager.Add(_table)

    local _player = _table:Player(player)

    -- _player.Hand:Push(Card.new("A", "Spades"))
    -- _player.Hand:Push(Card.new("K", "Diamonds"))
    -- _player.Hand.Cards = _player.Hand:Highest({Card.new("Q", "Clubs"),
    --                                            Card.new("J", "Hearts"),
    --                                            Card.new("10", "Spades"),
    --                                            Card.new("2", "Diamonds"),
    --                                            Card.new("3", "Clubs")})

    -- _player.Hand:Push(Card.new("A", "Spades"))
    -- _player.Hand:Push(Card.new("K", "Spades"))
    -- _player.Hand.Cards = _player.Hand:Highest({Card.new("Q", "Spades"),
    --                                            Card.new("J", "Spades"),
    --                                            Card.new("10", "Spades"),
    --                                            Card.new("2", "Diamonds"),
    --                                            Card.new("3", "Clubs")})

    -- _player.Hand:Push(Card.new("9", "Spades"))
    -- _player.Hand:Push(Card.new("A", "Diamonds"))
    -- _player.Hand.Cards = _player.Hand:Highest({Card.new("7", "Spades"),
    --                                            Card.new("6", "Spades"),
    --                                            Card.new("5", "Spades"),
    --                                            Card.new("8", "Spades"),
    --                                            Card.new("K", "Diamonds")})

    _player.Hand:Push(Card.new("A", "Spades"))
    _player.Hand:Push(Card.new("K", "Diamonds"))

    -- print(_player.Hand:Rank())
end)
