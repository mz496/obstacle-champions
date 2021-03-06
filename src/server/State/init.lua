local Object = require(game.ReplicatedStorage.Scripts.Object)
local Class = require(game.ReplicatedStorage.Scripts.Class)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local State, super = Class.classDefinition(Object)
State._className = "State"
State._new = --[[State]] function(self, name)
    self = super._new(self)
    self._name = name
    return self
end

State.execute = --[[void]] function(self)
    Utils.logInfo("Entered state: "..self._name)
end

State.getName = --[[string]] function(self)
    return self._name
end

State.__tostring = --[[string]] function(self)
    return "State<name="..self._name..">"
end

State.__eq = --[[boolean]] function(--[[State]] op1, --[[State]] op2)
    if op1 == nil then return false end
    if op2 == nil then return false end
    return op1._name == op2._name
end

return State
