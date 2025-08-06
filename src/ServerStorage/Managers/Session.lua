--!strict
-- Session Manager, keep track of all the sessions
local SessionManager = {}

function SessionManager.FindPlayerSession(player: Player): Session
    for _, session in ipairs(SessionManager) do
        if session.Players[player.UserId] then
            return session
        end
    end

    return nil
end

function SessionManager.Add(session: Session)
    table.insert(SessionManager, session)
end

return SessionManager
