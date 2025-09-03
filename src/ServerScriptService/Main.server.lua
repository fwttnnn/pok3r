--!strict
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Modules = ServerStorage:WaitForChild("Modules")
local Card = require(Modules.Poker.Card)
local Pile = require(Modules.Poker.Pile)
local Table = require(Modules.Poker.Table)

local Managers = ServerStorage:WaitForChild("Managers")
local SessionManager = require(Managers.Session)
local Session = require(Modules.Session)

local __players = {}

Players.PlayerAdded:Connect(function(player)
    -- table.insert(__players, player)
    -- if #__players < 2 then return end

    -- task.wait(2)
    
    -- local p2 = table.remove(__players)
    -- local p1 = table.remove(__players)

    -- local session = Session.new({p1, p2})
    -- SessionManager.Add(session)

    -- session:Start()

    local session = Session.new({player, {UserId = 666}})
    SessionManager.Add(session)

    session.Table.Cards.Community:Push(Card.new("6", "Spades"))
    session.Table.Cards.Community:Push(Card.new("4", "Hearts"))
    session.Table.Cards.Community:Push(Card.new("4", "Clubs"))
    session.Table.Cards.Community:Push(Card.new("8", "Clubs"))
    session.Table.Cards.Community:Push(Card.new("8", "Spades"))

    local _player1 = session.Table:GetPlayer(player)
    _player1.Hand:Push(Card.new("A", "Clubs"))
    _player1.Hand:Push(Card.new("3", "Spades"))

    local _player2 = session.Table:GetPlayer({UserId = 666})
    _player2.Hand:Push(Card.new("2", "Hearts"))
    _player2.Hand:Push(Card.new("7", "Hearts"))

    print(_player1.Hand:Best(session.Table.Cards.Community.Cards))
    print(Pile.new(_player1.Hand:Best(session.Table.Cards.Community.Cards)):Rank())

    print(_player2.Hand:Best(session.Table.Cards.Community.Cards))
    print(Pile.new(_player2.Hand:Best(session.Table.Cards.Community.Cards)):Rank())
end)
