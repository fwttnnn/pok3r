--!strict
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Functions = {
    Act = ReplicatedStorage.Functions.Session.Act,
}

local Managers = ServerStorage:WaitForChild("Managers")
local SessionManager = require(Managers.Session)

Functions.Act.OnServerInvoke = function(player, action)
    local session = SessionManager.FindPlayerSession(player)
    if not session then return false end

    return session:Act(player, action)
end
