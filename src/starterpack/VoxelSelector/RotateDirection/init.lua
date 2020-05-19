local Object = require(game.ReplicatedStorage.Scripts.Object)
local Class = require(game.ReplicatedStorage.Scripts.Class)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local RotateDirection, super = Class.classDefinition(Object)
RotateDirection._className = "RotateDirection"
RotateDirection._new = --[[RotateDirection]] function(self,
        --[[string]] name, --[[CFrame]] transformation)
    self = super._new(self)
    self._name = name
    self._transformation = transformation

    self._isActive = false
    return self
end

RotateDirection.getName = --[[string]] function(self)
    return self._name
end

RotateDirection.getTransformation = --[[CFrame]] function(self)
    return self._transformation
end

RotateDirection.getIsActive = --[[boolean]] function(self)
    return self._isActive
end

RotateDirection.setIsActive = --[[void]] function(self, isActive)
    self._isActive = isActive
end

return RotateDirection
