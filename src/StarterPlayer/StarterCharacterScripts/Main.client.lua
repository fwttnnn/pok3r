local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Deck = require(ReplicatedStorage:WaitForChild("Deck"))
local Card = require(ReplicatedStorage:WaitForChild("Card"))

-- local _c = Card.new()
-- local boardCardPivotPoint = CARDLINE.Position - Vector3.new((CARDLINE.Size.X / 2) - (_c.Part.Size.X / 2), 0, 0)
-- local nBoardCards = 0
-- _c.Part:Destroy()

local deck = Deck.new()

for i = 1, deck.MAXSIZE do
    deck:Push(Card.new())
end

local CARDLINE1 = workspace:WaitForChild("Board").CARDLINE1
local CARDLINE2 = workspace:WaitForChild("Board").CARDLINE2
local CARDLINE3 = workspace:WaitForChild("Board").CARDLINE3
local CARDLINE4 = workspace:WaitForChild("Board").CARDLINE4

task.wait(1.2)

deck:Deal(nil, CARDLINE1.Position, 0)
task.wait(0.5)
deck:Deal(nil, CARDLINE1.Position, 1)

task.wait(1.2)

deck:Deal(nil, CARDLINE2.Position, 0)
task.wait(0.5)
deck:Deal(nil, CARDLINE2.Position, 1)

task.wait(1.2)

deck:Deal(nil, CARDLINE3.Position, 0)
task.wait(0.5)
deck:Deal(nil, CARDLINE3.Position, 1)

task.wait(1.2)

deck:Deal(nil, CARDLINE4.Position, 0)
task.wait(0.5)
deck:Deal(nil, CARDLINE4.Position, 1)

-- deck:setTransparency(1)

-- deck.Part.ClickDetector.MouseClick:Connect(function()
--     local card = deck:pop()
--     card.Part.face.Transparency = 0

--     local TweenService = game:GetService("TweenService")
--     local tweenInfo = TweenInfo.new(
--         1, -- Time
--         Enum.EasingStyle.Quad, -- EasingStyle
--         Enum.EasingDirection.Out -- EasingDirection
--     )

--     local cardSpacing = card.Part.Size.X * 0.4
--     local targetPosition = CARDLINE.Position + Vector3.new(nBoardCards * cardSpacing, 0, -(nBoardCards * cardSpacing))

--     local tween = TweenService:Create(card.Part, tweenInfo, {
--         Position = targetPosition,
--         Orientation = Vector3.new(0, math.random(0, 120), 0)
--     })
--     tween:Play()

--     workspace.Invisible.Sound:Play()

--     nBoardCards += 1
--     deck:Resize()
-- end)
