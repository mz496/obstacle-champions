local Object = require(game.ReplicatedStorage.Common.Object)
local Class = require(game.ReplicatedStorage.Common.Class)
local Utils = require(game.ReplicatedStorage.Common.Utils)

local StateTransitionTable, super = Class.classDefinition(Object)
StateTransitionTable._className = "StateTransitionTable"
StateTransitionTable._new = --[[StateTransitionTable]] function(self, --[[StateTransition]] ...)
    self = super._new(self)
    self._transitions = args
    return self
end

StateTransitionTable.testEventForTransitionFromState = --[[boolean]] function(self, --[[Event]] event, --[[State]] state)
    for _, transition in ipairs(self._transitions) do
        if transition:shouldTransitionOn(event) then
            return transition:getToState()
        end
    end
    return nil
end

return StateTransitionTable

