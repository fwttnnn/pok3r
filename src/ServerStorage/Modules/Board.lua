local Board = {}
Board.__index = Board

function Board.new()
    return setmetatable({}, Board)
end

return Board
