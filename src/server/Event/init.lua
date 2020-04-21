local Object = require(game.ReplicatedStorage.Common.Object)
local Class = require(game.ReplicatedStorage.Common.Class)
local Utils = require(game.ReplicatedStorage.Common.Utils)

local Event, super = Class.classDefinition(Object)
Event._className = "Event"
Event._new = --[[Event]] function(self, name)
    self = super._new(self)
    self._name = name
    return self
end

Event.getName = --[[string]] function(self)
    return self._name
end

Event.__tostring = --[[string]] function(self)
    return "Event<name="..self._name..">"
end

Event.__eq = --[[boolean]] function(self, --[[Event]] op1, --[[Event]] op2)
    if op1 == nil then return false end
    if op2 == nil then return false end
    return op1._name == op2._name
end

return Event

