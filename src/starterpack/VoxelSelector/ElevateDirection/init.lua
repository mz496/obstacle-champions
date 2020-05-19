local Object = require(game.ReplicatedStorage.Scripts.Object)
local Class = require(game.ReplicatedStorage.Scripts.Class)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local ElevateDirection, super = Class.classDefinition(Object)
ElevateDirection._className = "ElevateDirection"
ElevateDirection._new = --[[FlyDirection]] function(self,
        --[[string]] name, --[[number -> number]] transformation)
    self = super._new(self)
    self._name = name
    self._transformation = transformation
    return self
end

ElevateDirection.getName = --[[string]] function(self)
    return self._name
end

ElevateDirection.getNewElevation = --[[number]] function(self, --[[number]] old)
    return self._transformation(old)
end

return ElevateDirection
