local Utils = require(game.ReplicatedStorage.Common.Utils)

local Object = {}
Object._className = "Object"
Object._new = --[[Object]] function(self)
    return self
end

Object.__tostring = --[[string]] function(self)
    return Utils.tableToString(self)
end

return Object

