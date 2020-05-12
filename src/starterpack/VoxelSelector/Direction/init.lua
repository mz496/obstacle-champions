local Object = require(game.ReplicatedStorage.Common.Object)
local Class = require(game.ReplicatedStorage.Common.Class)
local Utils = require(game.ReplicatedStorage.Common.Utils)

local Direction, super = Class.classDefinition(Object)
Direction._className = "Direction"
Direction._new = --[[Direction]] function(self,
        --[[string]] name, --[[Enum.KeyCode]] keyCode, --[[CFrame -> Ray]] rayTransformation)
    self = super._new(self)
    self._name = name
    self._keyCode = keyCode
    self._rayTransformation = rayTransformation

    self._goalRef = nil
    self._isActive = false
    return self
end

Direction.setGoalRef = --[[void]] function(self, --[[Part]] goal)
    self._goalRef = goal
end

Direction.getGoalRef = --[[Part]] function(self)
    return self._goalRef
end

Direction.getName = --[[string]] function(self)
    return self._name
end

Direction.getKeyCode = --[[Enum.KeyCode]] function(self)
    return self._keyCode
end

Direction.getRay = --[[Ray]] function(self, --[[CFrame]] rootCFrame)
    return self._rayTransformation(rootCFrame)
end

Direction.setIsActive = --[[void]] function(self, --[[boolean]] isActive)
    self._isActive = isActive
end

Direction.getIsActive = --[[void]] function(self)
    return self._isActive
end

return Direction
