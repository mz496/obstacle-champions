local Object = require(game.ReplicatedStorage.Scripts.Object)
local Class = require(game.ReplicatedStorage.Scripts.Class)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local Direction, super = Class.classDefinition(Object)
Direction._className = "Direction"
Direction._new = --[[Direction]] function(self,
        --[[string]] name, --[[Enum.KeyCode]] keyCode, --[[CFrame -> Vector3]] CFrameToUnitDirectionVector3Transformation)
    self = super._new(self)
    self._name = name
    self._keyCode = keyCode
    self._cFrameToUnitDirectionVector3Transformation = CFrameToUnitDirectionVector3Transformation

    self._ongoingVelocity = Vector3.new(0,0,0)
    return self
end

Direction.getName = --[[string]] function(self)
    return self._name
end

Direction.getKeyCode = --[[Enum.KeyCode]] function(self)
    return self._keyCode
end

Direction.getUnitDirectionVector3 = function(self, --[[CFrame]] rootCFrame)
    return self._cFrameToUnitDirectionVector3Transformation(rootCFrame)
end

Direction.setOngoingVelocity = --[[void]] function(self, --[[Vector3]] v)
    self._ongoingVelocity = v
end

Direction.getOngoingVelocity = --[[Vector3]] function(self)
    return self._ongoingVelocity
end

return Direction
