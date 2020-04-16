-- TODO: Create a shared datamodel for classpaths
local State = require(script.Parent.State)
local Event = require(script.Parent.Event)
local StateTransition = require(script.Parent.StateTransition)
local StateTransitionTable = require(script.Parent.StateTransitionTable)
local GameLifecycleManager = {}

GameLifecycleManager.new = --[[GameLifecycleManager]] function(self)
    local STATE_START = State:newInstance("Start")
    local STATE_END = State:newInstance("End")
    local STATE_TIE = State:newInstance("Tie")
    local EVENT_WIN = Event:new("Win")
    local EVENT_TIE = Event:new("Tie")
    local EVENT_LOSS = Event:new("Loss")
    self._currentState = STATE_START
    print("SHOULD BOTH BE STATE_START: "..tostring(STATE_START)..tostring(self._currentState))
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

