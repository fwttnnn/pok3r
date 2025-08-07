--!strict
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Modules = ServerStorage:WaitForChild("Modules")
local Card = require(Modules.Card)
local Session = require(Modules.Session)

local Managers = ServerStorage:WaitForChild("Managers")
local SessionManager = require(Managers.Session)

Players.PlayerAdded:Connect(function(player)
    local session = Session.new({player, {UserId = 69}})
    SessionManager.Add(session)

    local _player = session:GetPlayer(player)
    _player.Hand:Push(Card.new("2", "Hearts"))
    _player.Hand:Push(Card.new("3", "Hearts"))
    _player.Hand:Push(Card.new("4", "Hearts"))
    _player.Hand:Push(Card.new("A", "Hearts"))
    _player.Hand:Push(Card.new("5", "Hearts"))
    _player.Hand.Cards = _player.Hand:Highest({})
    print(_player.Hand:Rank())
end)
