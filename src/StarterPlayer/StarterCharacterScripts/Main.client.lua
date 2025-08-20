local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = {
    Event = {
        Turn = ReplicatedStorage.Events.Session.Turn,
    },
    Function = {
        Act = ReplicatedStorage.Functions.Session.Act,
    },
}

Remote.Event.Turn.OnClientEvent:Connect(function()
    -- wait(1)
    -- Remote.Function.Act:InvokeServer({Type = "BET", Amount = 100})
end)
