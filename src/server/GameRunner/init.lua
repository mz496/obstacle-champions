local GameLifecycleManager = require(game.ServerScriptService.Server.GameLifecycleManager)
local StateTransition = require(game.ServerScriptService.Server.StateTransition)
local StateTransitionTable = require(game.ServerScriptService.Server.StateTransitionTable)
local GameLifecycleConstants = require(game.ServerScriptService.Server.Constants.GameLifecycle)
local States = GameLifecycleConstants.States
local Events = GameLifecycleConstants.Events
local PlayerState = require(game.ServerScriptService.Server.PlayerState)
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
local PLAYERS_QUEUED = {}
local PLAYERS_ACTIVE = {}

-- At the beginning of a round, this is the number displayed to the player; changes just before entering obstacle run state
local _roundNumber = 1

local _gameInProgress = false

local onTransition = function(from, to)
    Utils.logInfo("ROUND "..tostring(_roundNumber).." "..tostring(from).."->"..tostring(to))
end

GameRunner.addQueuedPlayer = function(player)
    Utils.logInfo("Queueing player to upcoming game " .. player.Name)
    PLAYERS_QUEUED[player.Name] = PlayerState(player.Name, 0, 0)
end

GameRunner.removeQueuedPlayer = function(player)
    Utils.logInfo("Removing queued player from upcoming game " .. player.Name)
    PLAYERS_QUEUED[player.Name] = nil
end

GameRunner.removeActivePlayer = function(player)
    if (not _gameInProgress) then
        Utils.logWarn("Game not in progress, can't remove " .. player.Name)
    else
        Utils.logInfo("Removing active player from game " .. player.Name)
        -- TODO: Persist player's current score
        PLAYERS_ACTIVE[player.Name] = nil
    end
end

local setup = function()
    _gameInProgress = true
    Utils.logInfo("Moving all queued players to active players: queued="..Utils.tableToString(PLAYERS_QUEUED)..", active="..Utils.tableToString(PLAYERS_ACTIVE))
    PLAYERS_ACTIVE = {}
    for playerName,playerState in pairs(PLAYERS_QUEUED) do
        PLAYERS_ACTIVE[playerName] = playerState
    end
    PLAYERS_QUEUED = {}
    Utils.logInfo("Moving all queued players to active players: queued="..Utils.tableToString(PLAYERS_QUEUED)..", active="..Utils.tableToString(PLAYERS_ACTIVE))
    Utils.logInfo("Preparing game with " .. Utils.tableToString(PLAYERS_ACTIVE))
end

local teardown = function()
    _gameInProgress = false
    Utils.logInfo("Ending game with " .. Utils.tableToString(PLAYERS_ACTIVE))
end

GameRunner.init = function(self)
    MANAGER = GameLifecycleManager:init(States.WAITING_TO_START, TRANSITION_TABLE, onTransition)
    return self
end

GameRunner.startGame = function()
    Utils.logInfo("Starting game")
    MANAGER:acceptEvent(Events.GAME_PREP_INITIATED)
    setup()
    MANAGER:acceptEvent(Events.GAME_PREP_FINISHED)
    while (_roundNumber <= ROUND_COUNT) do
        MANAGER:acceptEvent(Events.OBSTACLE_CHOICE_TIMEOUT)
        MANAGER:acceptEvent(Events.OBSTACLE_PLACEMENT_TIMEOUT)
        Utils.logInfo("WAITING FOR OBSTACLE RUN TO COMPLETE...")
        wait(10)
        _roundNumber = _roundNumber + 1
        if (_roundNumber <= ROUND_COUNT) then
            MANAGER:acceptEvent(Events.OBSTACLE_RUN_TIMEOUT)
        else
            break
        end
    end
    teardown()
    MANAGER:acceptEvent(Events.GAME_FINISHED)
end

GameRunner.noOneInProgress = function()
    MANAGER:acceptEvent(Events.OBSTACLE_RUN_NO_ONE_IN_PROGRESS)
end

GameRunner.incrementRoundScore = function(player, increment)
    PLAYERS[player.Name]:setCurrentRoundScore(PLAYERS[player.Name]:getCurrentRoundScore() + increment)
    Utils.logInfo("Incremented "..player.Name.."'s score by "..Utils.truncateNumber(increment)..", now "..Utils.truncateNumber(PLAYERS[player.Name]:getCurrentRoundScore()))
end

return GameRunner
