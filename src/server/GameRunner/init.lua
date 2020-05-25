local GameLifecycleManager = require(game.ServerScriptService.Server.GameLifecycleManager)
local StateTransition = require(game.ServerScriptService.Server.StateTransition)
local StateTransitionTable = require(game.ServerScriptService.Server.StateTransitionTable)
local GameLifecycleConstants = require(game.ServerScriptService.Server.Constants.GameLifecycle)
local States = GameLifecycleConstants.States
local Events = GameLifecycleConstants.Events
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local GameRunner = {}

local TRANSITION_TABLE = StateTransitionTable({
        StateTransition(States.WAITING_TO_START, States.GAME_PREP, {Events.GAME_PREP_INITIATED}),
        StateTransition(States.GAME_PREP, States.OBSTACLE_CHOICE, {Events.GAME_PREP_FINISHED}),
        StateTransition(States.OBSTACLE_CHOICE, States.OBSTACLE_PLACEMENT, {Events.OBSTACLE_CHOICE_TIMEOUT}),
        StateTransition(States.OBSTACLE_PLACEMENT, States.OBSTACLE_RUN, {Events.OBSTACLE_PLACEMENT_TIMEOUT}),
        StateTransition(States.OBSTACLE_RUN, States.OBSTACLE_CHOICE, {Events.OBSTACLE_RUN_TIMEOUT, Events.OBSTACLE_RUN_NO_ONE_IN_PROGRESS}),
        StateTransition(States.OBSTACLE_RUN, States.GAME_END, {Events.GAME_FINISHED})
    })

local MANAGER = nil
local ROUND_COUNT = 5

-- At the beginning of a round, this is the number displayed to the player; changes just before entering obstacle run state
local _roundNumber = 1

local onTransition = function(from, to)
    if (to == States.OBSTACLE_RUN) then
        _roundNumber = _roundNumber + 1
    end
    Utils.logInfo("ROUND "..tostring(_roundNumber).." "..tostring(from).."->"..tostring(to))
end

GameRunner.init = function(self)
    MANAGER = GameLifecycleManager:init(States.WAITING_TO_START, TRANSITION_TABLE, onTransition)
    return self
end

GameRunner.startGame = function()
    Utils.logInfo("Starting game")
    MANAGER:acceptEvent(Events.GAME_PREP_INITIATED)
    MANAGER:acceptEvent(Events.GAME_PREP_FINISHED)
    while (_roundNumber < ROUND_COUNT) do
        MANAGER:acceptEvent(Events.OBSTACLE_CHOICE_TIMEOUT)
        MANAGER:acceptEvent(Events.OBSTACLE_PLACEMENT_TIMEOUT)
        Utils.logInfo("WAITING FOR OBSTACLE RUN TO COMPLETE...")
        wait(10)
        if (_roundNumber < ROUND_COUNT) then
            MANAGER:acceptEvent(Events.OBSTACLE_RUN_TIMEOUT)
        else
            MANAGER:acceptEvent(Events.GAME_FINISHED)
        end
    end
end

GameRunner.noOneInProgress = function()
    MANAGER:acceptEvent(Events.OBSTACLE_RUN_NO_ONE_IN_PROGRESS)
end

return GameRunner
