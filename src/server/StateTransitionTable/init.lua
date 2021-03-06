local Object = require(game.ReplicatedStorage.Scripts.Object)
local Class = require(game.ReplicatedStorage.Scripts.Class)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local StateTransitionTable, super = Class.classDefinition(Object)
StateTransitionTable._className = "StateTransitionTable"
StateTransitionTable._new = --[[StateTransitionTable]] function(self, --[[ StateTransition[] ]] transitions)
    self = super._new(self)
    self._transitions = transitions
    return self
end

StateTransitionTable.testEventForTransitionFromState = --[[boolean]] function(self, --[[Event]] event, --[[State]] from)
    for _, transition in pairs(self._transitions) do
        if transition:getFromState() == from and transition:shouldTransitionOn(event) then
            return transition:getToState()
        end
    end
    return nil
end

return StateTransitionTable
