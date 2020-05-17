-- TODO: Create a shared datamodel for classpaths?
local State =
require(game.ServerScriptService.Server.State)
local Event =
require(game.ServerScriptService.Server.Event)
local StateTransition =
require(game.ServerScriptService.Server.StateTransition)
local StateTransitionTable =
require(game.ServerScriptService.Server.StateTransitionTable)
local Utils =
require(game.ReplicatedStorage.Scripts.Utils)
local GameLifecycleConstants =
require(game.ServerScriptService.Server.Constants.GameLifecycle)
local States = GameLifecycleConstants.States
local Events = GameLifecycleConstants.Events

--[[
GameLifecycleManager is a singleton managing the game state.
It accepts events and transitions to new states accordingly using acceptEvent(self, event).
]]
local GameLifecycleManager = {}

GameLifecycleManager.new = --[[GameLifecycleManager]] function(self)
    self._currentState = States.START

    self._transitionTable = StateTransitionTable({
        StateTransition(States.START, States.END, {Events.WIN, Events.LOSS}),
        StateTransition(States.START, States.TIE, {Events.TIE})
    })
    return self
end

GameLifecycleManager.acceptEvent = --[[void]] function(self, --[[Event]] event)
    print("accepted event: " .. tostring(event))
    -- TODO: Have an event queue
    self:_handleEvent(event)
end

GameLifecycleManager.getCurrentState = --[[State]] function(self)
    return self._currentState
end

GameLifecycleManager._handleEvent = --[[void]] function(self, --[[Event]] event)
    print("handling event: " .. tostring(event))
    local testForTransitionState = self._transitionTable:testEventForTransitionFromState(event, self._currentState)
    if testForTransitionState ~= nil then
        print("transitioning from "..tostring(self._currentState).." to "..tostring(testForTransitionState))
        self._currentState = testForTransitionState
    end
end

return GameLifecycleManager

