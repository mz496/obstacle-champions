local Object = require(game.ReplicatedStorage.Scripts.Object)
local Class = require(game.ReplicatedStorage.Scripts.Class)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local StateTransition, super = Class.classDefinition(Object)
StateTransition._className = "StateTransition"
StateTransition._new = --[[StateTransition]] function(self, --[[State]] from, --[[State]] to, --[[ Event[] ]] on)
    self = super._new(self)
    self._from = from
    self._to = to
    -- TODO: Extract into this a library
    self._transitionSet = {}
    for _, event in ipairs(on) do
        self._transitionSet[event] = true
    end
    return self
end

StateTransition.shouldTransitionOn = --[[boolean]] function(self, --[[Event]] event)
    if self._transitionSet[event] then
        return true
    else
        return false
    end
end

StateTransition.getToState = --[[State]] function(self)
    return self._to
end

return StateTransition

