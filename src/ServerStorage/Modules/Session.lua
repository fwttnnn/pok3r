--!strict
local Session = {}
Session.__index = Session

local ServerStorage = game:GetService("ServerStorage")
local Modules = ServerStorage:WaitForChild("Modules")

local Table = require(Modules.Poker.Table)
local Timer = require(Modules.Timer)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = {
    Turn = ReplicatedStorage.Events.Session.Turn,
}

function Session.new(players: {[number]: Player})
    assert(#players >= 2) -- TODO: should check on table too

    return setmetatable({
        Table = Table.new(players),
        Timer = Timer.new(),
        State = {
            Started = false,
            Turn = 0,
            Player = {
                Current = {
                    Acted = false,
                    Index = 0,
                },
            },
            Last = {
                Action = {
                    Type = nil,
                    Amount = nil,
                },
            },
        },
    }, Session)
end

function Session:Start()
    self.State.Started = true
    self.Timer.Finished:Connect(function()
        if self.State.Player.Current.Acted then return end

        print("[session] you took too long")

        local _player = self:GetTurnPlayer()

        -- TODO: ...
        if self.State.Last.Action.Type == nil or self.State.Last.Action.Type == "CHECK" then
            self:Act(_player.Player, { Type = "CHECK" })
        elseif self.State.Last.Action.Type == "BET" or self.State.Last.Action.Type == "RAISE" or self.State.Last.Action.Type == "CALL" then
            self:Act(_player.Player, { Type = "CALL" })
        end
    end)

    self:NextTurn()
end

function Session:IsOver(): boolean
    local actives = 0

    for _, player in ipairs(self.Table.Players) do
        if player.Active then
            actives += 1
        end
    end

    return actives == 1
end

function Session:GetTurnPlayer()
    return self.Table.Players[self.State.Player.Current.Index]
end

function Session:SetNextPlayer()
    self.State.Player.Current.Index = (self.State.Player.Current.Index % #self.Table.Players) + 1
    if self.State.Player.Current.Index == 1 then self.State.Turn += 1 end

    while not self.Table.Players[self.State.Player.Current.Index].Active do
        self.State.Player.Current.Index = (self.State.Player.Current.Index % #self.Table.Players) + 1
        if self.State.Player.Current.Index == 1 then self.State.Turn += 1 end
    end
end

function Session:IsPlayerTurn(player: Player): boolean
    return player.UserId == self.Table.Players[self.State.Player.Current.Index].Id
end

function Session:Act(player: Player, action): boolean
    if not self.State.Started then return false end
    if not self:IsPlayerTurn(player) then return false end

    local _player = self.Table:GetPlayer(player)
    if not _player then return false end

    local handlers = {
        BET = function()
            local amount = action.Amount
            if amount <= 0 then return false end
            if _player.Chips < amount then return false end

            _player.Chips -= amount
            self.Table.Pot += amount
            print("[bet] pot increased", _player.Chips, self.Table.Pot)
            return true
        end,

        CALL = function()
            local lastAction = self.State.Last.Action
            if not (lastAction.Type == "BET" or lastAction.Type == "RAISE") then return false end

            local amount = lastAction.Amount
            if amount <= 0 then return false end
            if _player.Chips < amount then return false end

            _player.Chips -= amount
            self.Table.Pot += amount

            print("[call] pot increased", _player.Chips, self.Table.Pot)
            return true
        end,

        RAISE = function()
            local lastAction = self.State.Last.Action
            if not (lastAction.Type == "BET" or lastAction.Type == "RAISE") then return false end

            local threshold = 20
            local amount = action.Amount

            if amount <= 0 then return false end
            if lastAction.Amount > amount - threshold then return false end
            if _player.Chips < amount then return false end

            _player.Chips -= amount
            self.Table.Pot += amount

            print("[raise] pot increased", _player.Chips, self.Table.Pot)
            return true
        end,

        CHECK = function()
            print("[check] game continues", _player.Chips, self.Table.Pot)
            return true
        end,

        FOLD = function()
            _player.Active = false
            print("[fold] player dies", _player.Chips, self.Table.Pot)
            return true
        end,
    }

    local handler = handlers[action.Type]
    if not handler then return false end

    local accepted = handler()
    if accepted then
        self.State.Player.Current.Acted = true
        self.State.Last.Action = action

        self.Timer:Stop()
        self.Timer:Reset()

        self:NextTurn()
    end

    return accepted
end

function Session:NextTurn()
    self:SetNextPlayer()

    -- NOTE: for testing
    self.State.Player.Current.Index = 1 

    local _player = self:GetTurnPlayer()

    self.State.Player.Current.Acted = false
    Events.Turn:FireClient(_player.Player)

    self.Timer:Start(2)
end

return Session
