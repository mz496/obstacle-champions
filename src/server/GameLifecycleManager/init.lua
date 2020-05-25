local State = require(game.ServerScriptService.Server.State)
local Event = require(game.ServerScriptService.Server.Event)
local StateTransition = require(game.ServerScriptService.Server.StateTransition)
local StateTransitionTable = require(game.ServerScriptService.Server.StateTransitionTable)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

--[[
GameLifecycleManager is a singleton managing the game state.
It accepts events and transitions to new states accordingly using acceptEvent(self, event).
]]
local GameLifecycleManager = {}

GameLifecycleManager.init = --[[GameLifecycleManager]] function(self, --[[State]] startState, --[[StateTransitionTable]] transitionTable, onTransitionFunction)
    self._currentState = startState
    self._transitionTable = transitionTable
    self._onTransitionFunction = onTransitionFunction
    Utils.logDebug("Initializing game lifecycle manager with start state "..tostring(startState))
    return self
end

GameLifecycleManager.acceptEvent = --[[void]] function(self, --[[Event]] event)
    -- TODO: Have an event queue
    self:_handleEvent(event)
end

GameLifecycleManager.getCurrentState = --[[State]] function(self)
    return self._currentState
end

GameLifecycleManager._handleEvent = --[[void]] function(self, --[[Event]] event)
    Utils.logDebug("Handling event: " .. tostring(event))
    local testForTransitionState = self._transitionTable:testEventForTransitionFromState(event, self._currentState)
    if testForTransitionState ~= nil then
        Utils.logDebug("Transitioning from "..tostring(self._currentState).." to "..tostring(testForTransitionState))
        self._onTransitionFunction(self._currentState, testForTransitionState)
        self._currentState = testForTransitionState
    else
        Utils.logDebug("Discarding event "..tostring(event))
    end
end

return GameLifecycleManager
