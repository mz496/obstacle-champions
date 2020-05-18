local Object = require(game.ReplicatedStorage.Scripts.Object)
local Class = require(game.ReplicatedStorage.Scripts.Class)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local Direction, super = Class.classDefinition(Object)
Direction._className = "Direction"
Direction._new = --[[Direction]] function(self,
        --[[string]] name, --[[CFrame -> Vector3]] cFrameToUnitDirectionVector3Transformation)
    self = super._new(self)
    self._name = name
    self._cFrameToUnitDirectionVector3Transformation = cFrameToUnitDirectionVector3Transformation

    self._ongoingVelocity = Vector3.new(0,0,0)
    return self
end

Direction.getName = --[[string]] function(self)
    return self._name
end

Direction.getUnitDirectionVector3 = --[[Vector3]] function(self, --[[CFrame]] rootCFrame)
    return self._cFrameToUnitDirectionVector3Transformation(rootCFrame)
end

Direction.setOngoingVelocity = --[[void]] function(self, --[[Vector3]] v)
    self._ongoingVelocity = v
end

Direction.getOngoingVelocity = --[[Vector3]] function(self)
    return self._ongoingVelocity
end

return Direction
