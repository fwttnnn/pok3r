local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = {
    Match = {
        Rematch = {
            Act = ReplicatedStorage.Events.Match.Rematch.Act,
            Acted = ReplicatedStorage.Events.Match.Rematch.Acted,
            Join = ReplicatedStorage.Events.Match.Rematch.Join,
            Quit = ReplicatedStorage.Events.Match.Rematch.Quit,
        },
        Turn = {
            Started = ReplicatedStorage.Events.Match.Turn.Started,
            Betting = {
                Started = ReplicatedStorage.Events.Match.Turn.Betting.Started,
                Act = ReplicatedStorage.Events.Match.Turn.Betting.Act,
                Acted = ReplicatedStorage.Events.Match.Turn.Betting.Acted,
                Action = ReplicatedStorage.Events.Match.Turn.Betting.Action,
            },
        },
    },
}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local health = 0
local actions = {
    -- NOTE: action 'Fold' will never appear here.
    Last = {
        Type = nil,
        Amount = nil,
    },
}

function disableButtons()
    for _, obj in PlayerGui.ScreenGui.Buttons:GetDescendants() do
        if not obj:IsA("TextButton") then continue end

        local button: TextButton = obj
        button.Active = false
        button.Interactable = false

        local frame: Frame = button.Parent
        frame.Visible = false
    end
end

function enableButtons()
    for _, obj in PlayerGui.ScreenGui.Buttons:GetDescendants() do
        if not obj:IsA("TextButton") then continue end

        local button: TextButton = obj
        button.Active = true
        button.Interactable = true

        local frame: Frame = button.Parent
        frame.Visible = true
    end
end

function setButtonCallback(button, fn)
    if button.Connection then
        button.Connection:Disconnect()
    end

    button.Connection = button.GUI.MouseButton1Click:Connect(fn)
end

--
-- Buttons
--

local Buttons = {}
for _, obj in PlayerGui.ScreenGui.Buttons:GetDescendants() do 
    if not obj:IsA("TextButton") then continue end

    local button: Button = obj
    local name: string = button.Parent.Name

    Buttons[name] = {
        GUI = button,
        Connection = nil,
    }
end

Buttons.Upper = {}
for _, obj in PlayerGui.ScreenGui.Buttons.Upper:GetDescendants() do 
    if not obj:IsA("TextButton") then continue end

    local button: Button = obj
    local name: string = button.Parent.Name

    Buttons.Upper[name] = {
        GUI = button,
        Connection = nil,
    }
end

-- NOTE: naming based on last action
local buttonLayouts = {}

buttonLayouts.Check = function()
    Buttons.Left.GUI.Text = "CHECK"
    setButtonCallback(Buttons.Left, function()
        Events.Match.Turn.Betting.Act:FireServer({Type = "CHECK"})
    end)

    Buttons.Middle.GUI.Text = "ALL IN"
    setButtonCallback(Buttons.Middle, function()
        Events.Match.Turn.Betting.Act:FireServer({Type = "ALL IN"})
    end)

    Buttons.Right.GUI.Text = "BET"
    setButtonCallback(Buttons.Right, function()
        -- TODO: create a user input
        local amount = 10

        if health < amount then
            print("[client/bet] cannot bet, you don't have enough health")
            return
        end

        Events.Match.Turn.Betting.Act:FireServer({Type = "BET", Amount = amount})
    end)

    Buttons.Upper.Right.GUI.Text = "FOLD"
    setButtonCallback(Buttons.Upper.Right, function()
        Events.Match.Turn.Betting.Act:FireServer({Type = "FOLD"})
    end)
end

buttonLayouts.Call = function()
    Buttons.Left.GUI.Text = "CALL"
    setButtonCallback(Buttons.Left, function()
        Events.Match.Turn.Betting.Act:FireServer({Type = "CALL"})
    end)

    Buttons.Middle.GUI.Text = "ALL IN"
    setButtonCallback(Buttons.Middle, function()
        Events.Match.Turn.Betting.Act:FireServer({Type = "ALL IN"})
    end)

    Buttons.Right.GUI.Text = "RAISE"
    setButtonCallback(Buttons.Right, function()
        -- TODO: create a user input
        assert(actions.Last.Amount ~= nil)
        local amount = 10

        if health < actions.Last.Amount + amount then
            print("[client/raise] cannot raise, you don't have enough health")
            return
        end

        Events.Match.Turn.Betting.Act:FireServer({Type = "RAISE", Amount = amount})
    end)

    Buttons.Upper.Right.GUI.Text = "FOLD"
    setButtonCallback(Buttons.Upper.Right, function()
        Events.Match.Turn.Betting.Act:FireServer({Type = "FOLD"})
    end)
end

buttonLayouts.Fold      = function() buttonLayouts[actions.Last.Type or "Default"]() end
buttonLayouts.Bet       = buttonLayouts.Call
buttonLayouts["All In"] = buttonLayouts.Bet
buttonLayouts["Raise"]  = buttonLayouts.Bet
buttonLayouts.Default   = buttonLayouts.Check

disableButtons()
buttonLayouts.Default()

--
-- Events
--

Events.Match.Turn.Started.OnClientEvent:Connect(function(_health)
    health = _health
    actions.Last = {
        Type = nil,
        Amount = nil,
    }
end)

Events.Match.Turn.Betting.Act.OnClientEvent:Connect(function(_health)
    enableButtons()
    health = _health
end)

Events.Match.Turn.Betting.Acted.OnClientEvent:Connect(function(_health)
    disableButtons()
    health = _health
end)

Events.Match.Turn.Betting.Action.OnClientEvent:Connect(function(player, action)
    -- NOTE: why the hell doesn't lua have a standard library duddd..
    -- SEE: http://lua-users.org/wiki/SciteTitleCase
    local function capitalize(str: string): string
        local buf = {}
        local inWord = false

        for i = 1, #str do
            local c = string.sub(str, i, i)
            if inWord then
                table.insert(buf, string.lower(c))
                if string.find(c, '%s') then
                    inWord = false
                end
            else
                table.insert(buf, string.upper(c))
                inWord = true
            end
        end

        return table.concat(buf)
    end

    action.Type = capitalize(action.Type)
    buttonLayouts[action.Type]()

    if action.Type == "Fold" then
        return
    end

    actions.Last = action
end)

Events.Match.Turn.Betting.Started.OnClientEvent:Connect(function()
    actions.Last = {
        Type = nil,
        Amount = nil,
    }

    buttonLayouts.Default()
end)

local joinButton = PlayerGui.ScreenGui.Join.Join
local quitButton = PlayerGui.ScreenGui.Quit.Quit

joinButton.MouseButton1Click:Connect(function()
    Events.Match.Rematch.Join:FireServer()
end)

quitButton.MouseButton1Click:Connect(function()
    Events.Match.Rematch.Quit:FireServer()
end)

Events.Match.Rematch.Act.OnClientEvent:Connect(function()
    joinButton.Active = true
    joinButton.Interactable = true
    joinButton.Parent.Visible = true

    quitButton.Active = true
    quitButton.Interactable = true
    quitButton.Parent.Visible = true
end)

Events.Match.Rematch.Acted.OnClientEvent:Connect(function()
    joinButton.Active = false
    joinButton.Interactable = false
    joinButton.Parent.Visible = false

    quitButton.Active = false
    quitButton.Interactable = false
    quitButton.Parent.Visible = false
end)
