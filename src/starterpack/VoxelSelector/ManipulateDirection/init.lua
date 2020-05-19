local Object = require(game.ReplicatedStorage.Scripts.Object)
local Class = require(game.ReplicatedStorage.Scripts.Class)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local ManipulateDirection, super = Class.classDefinition(Object)
ManipulateDirection._className = "ManipulateDirection"
ManipulateDirection._new = --[[ManipulateDirection]] function(self,
        --[[string]] name, --[[CFrame]] transformation)
    self = super._new(self)
    self._name = name
    self._transformation = transformation

    self._isActive = false
    return self
end

ManipulateDirection.getName = --[[string]] function(self)
    return self._name
end

ManipulateDirection.getTransformation = --[[CFrame]] function(self)
    return self._transformation
end

ManipulateDirection.getIsActive = --[[boolean]] function(self)
    return self._isActive
end

ManipulateDirection.setIsActive = --[[void]] function(self, isActive)
    self._isActive = isActive
end

return ManipulateDirection
