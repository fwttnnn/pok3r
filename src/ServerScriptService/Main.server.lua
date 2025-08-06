--!strict
local ServerStorage = game:GetService("ServerStorage")
local Modules = ServerStorage:WaitForChild("Modules")
local Managers = ServerStorage:WaitForChild("Managers")

local Session = require(Modules.Session)
local SessionManager = require(Managers.Session)

wait(1) 

local Players = game:GetService("Players")
local allPlayers = {}

for _, player in pairs(Players:GetPlayers()) do
    table.insert(allPlayers, player)
end

local me = allPlayers[1]

table.insert(SessionManager, Session.new({me, {UserId = 666}}))
local session = SessionManager.FindPlayerSession(me)

-- session:Deal(me)
-- session:Deal(me)
-- session:Deal(me)
-- session:Deal(me)
-- session:Deal(me)

local Card = require(Modules.Card)

local _player = session:GetPlayer(me)

-- _player.Hand:Push(Card.new("A", "Hearts"))
-- _player.Hand:Push(Card.new("6", "Hearts"))
-- _player.Hand:Push(Card.new("7", "Hearts"))
-- _player.Hand:Push(Card.new("6", "Clubs"))
-- _player.Hand:Push(Card.new("3", "Hearts"))

_player.Hand:Push(Card.new("A", "Hearts"))
_player.Hand:Push(Card.new("2", "Hearts"))
_player.Hand:Push(Card.new("3", "Hearts"))
_player.Hand:Push(Card.new("4", "Hearts"))
_player.Hand:Push(Card.new("5", "Hearts"))

_player.Hand:Sort()
print(_player.Hand:Rank())
