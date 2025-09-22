--!strict
local _Player = {}

function _Player.Disconnected(player: Player): boolean
    if not player then return true end
    return player.Parent == nil
end

return _Player
