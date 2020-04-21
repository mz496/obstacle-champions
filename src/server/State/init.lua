local Object = require(game.ReplicatedStorage.Common.Object)
local Class = require(game.ReplicatedStorage.Common.Class)
local Utils = require(game.ReplicatedStorage.Common.Utils)

local State, super = Class.classDefinition(Object)
State._className = "State"
State._new = --[[State]] function(self, name)
    self = super._new(self)
    self._name = name
    return self
end

State.execute = --[[void]] function(self)
    Utils.logWarn("base execution logic was not overridden")
end

State.getName = --[[string]] function(self)
    return self._name
end

State.__tostring = --[[string]] function(self)
    return "State<name="..self._name..">"
end

State.__eq = --[[boolean]] function(self, --[[State]] op1, --[[State]] op2)
    if op1 == nil then return false end
    if op2 == nil then return false end
    return op1._name == op2._name
end

return State

