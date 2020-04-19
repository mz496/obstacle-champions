-- TODO: Create a shared datamodel for classpaths
local State = require(script.Parent.State)
local Event = require(script.Parent.Event)
local StateTransition = require(script.Parent.StateTransition)
local StateTransitionTable = require(script.Parent.StateTransitionTable)
local Utils = require(game.ReplicatedStorage.Common.Utils)
local GameLifecycleManager = {}

GameLifecycleManager.new = --[[GameLifecycleManager]] function(self)
    local STATE_START = State("Start")
    STATE_START.execute = function(self)
        Utils.logInfo("start state")
    end
    local STATE_END = State("End")
    STATE_END.execute = function(self)
        Utils.logInfo("end state")
    end
    local STATE_TIE = State("Tie")
    STATE_TIE.execute = function(self)
        Utils.logInfo("tie state")
    end
    local EVENT_WIN = Event:new("Win")
    local EVENT_TIE = Event:new("Tie")
    local EVENT_LOSS = Event:new("Loss")
    self._currentState = STATE_START

    self._transitionTable = StateTransitionTable:new(
        StateTransition:new(STATE_START, STATE_END, {EVENT_WIN, EVENT_LOSS}),
        StateTransition:new(STATE_START, STATE_TIE, {EVENT_TIE}))
    return self
end

GameLifecycleManager.acceptEvent = --[[void]] function(self, --[[Event]] event)
    print("accepted event: " .. tostring(event))
    -- TODO: Have an event queue
    self._handleEvent(event)
end

GameLifecycleManager.getCurrentState = --[[State]] function(self)
    return self._currentState
end

GameLifecycleManager._handleEvent = --[[void]] function(self, --[[Event]] event)
    print("handling event: " .. tostring(event))
    local testForTransitionState =self._transitionTable:testEventForTransitionFromState(event, self._currentState)
    if testForTransitionState ~= nil then
        print("transitioning from "..tostring(self._currentState).." to "..tostring(testForTransitionState))
        self._currentState = testForTransitionState
    end
end

return GameLifecycleManager

