local Ox = require '@ox_core/lib/init'

local Player = {}

function Player.get()
    return Ox.GetPlayer()
end

function Player.isInGroup(groupName)
    local player = Player.get()
    return player.getGroup(groupName) ~= nil
end

return Player
