local Card = {}
Card.__index = Card

function Card.new()
    local template: Part = workspace:WaitForChild("Board").CARDEXAMPLE
    local part: Part = template:Clone()

    part.Name = "Card"

    return setmetatable({
        Part = part
    }, Card)
end

function Card:setTransparency(transparency: number)
    self.Part.Transparency = transparency
    self.Part.Decal.Transparency = transparency
    self.Part.face.Transparency = transparency
end

return Card
