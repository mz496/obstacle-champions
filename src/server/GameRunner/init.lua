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

local setGameInProgress = function(bool) game.ServerStorage.State.IsGameInProgress.Value = bool end
local getGameInProgress = function() return game.ServerStorage.State.IsGameInProgress.Value end
local getActivePlayers = function() return game.ServerStorage.State.ActivePlayers end
local getQueuedPlayers = function() return game.ServerStorage.State.QueuedPlayers end
local getRoundNumber = function() return game.ServerStorage.State.RoundNumber.Value end
local setRoundNumber = function(int) game.ServerStorage.State.RoundNumber.Value = int end
local onTransition = function(from, to)
    Utils.logInfo("ROUND "..tostring(getRoundNumber()).." "..tostring(from).."->"..tostring(to))
end

GameRunner.addQueuedPlayer = function(player)
    Utils.logInfo("Queueing player to upcoming game " .. player.Name)
    local playerValue = PlayerState(player.Name, 0, 0):toValue()
    playerValue.Parent = getQueuedPlayers()
end

GameRunner.removeQueuedPlayer = function(player)
    Utils.logInfo("Removing queued player from upcoming game " .. player.Name)
    local playerValue = getQueuedPlayers()[player.Name]
    playerValue.Parent = nil
    playerValue:Destroy()
    playerValue = nil
end

GameRunner.removeActivePlayer = function(player)
    if (not game.ServerStorage.State.IsGameInProgress.Value) then
        Utils.logWarn("Game not in progress, can't remove " .. player.Name)
    else
        Utils.logInfo("Removing active player from game " .. player.Name)
        -- TODO: Persist player's current score
        local playerValue = getActivePlayers()[player.Name]
        playerValue.Parent = nil
        playerValue:Destroy()
        playerValue = nil
    end
end

local setup = function()
    setGameInProgress(true)
    Utils.logInfo("Moving all queued players to active players: queued="..Utils.tableToString(game.ServerStorage.State.QueuedPlayers:GetChildren())..", active="..Utils.tableToString(game.ServerStorage.State.ActivePlayers:GetChildren()))
    for _, playerState in pairs(getQueuedPlayers():GetChildren()) do
        playerState.Parent = getActivePlayers()
    end
    Utils.logInfo("Moving all queued players to active players: queued="..Utils.tableToString(game.ServerStorage.State.QueuedPlayers:GetChildren())..", active="..Utils.tableToString(game.ServerStorage.State.ActivePlayers:GetChildren()))
end

local teardown = function()
    Utils.logInfo("teardown")
    setGameInProgress(false)
end

GameRunner.init = function()
    GameRunner._GAME_LIFECYCLE_MANAGER = GameLifecycleManager:init(States.WAITING_TO_START, TRANSITION_TABLE, onTransition)
    GameRunner._ROUND_COUNT = 5
    local queuedPlayers = Instance.new("Model", game.ServerStorage.State)
    queuedPlayers.Name = "QueuedPlayers"
    local activePlayers = Instance.new("Model", game.ServerStorage.State)
    activePlayers.Name = "ActivePlayers"
    local roundNumber = Instance.new("IntValue", game.ServerStorage.State)
    roundNumber.Name = "RoundNumber"
    roundNumber.Value = 1
    local gameInProgress = Instance.new("BoolValue", game.ServerStorage.State)
    gameInProgress.Name = "IsGameInProgress"
    gameInProgress.Value = false
end

GameRunner.startGame = function()
    GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.GAME_PREP_INITIATED)
    setup()
    GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.GAME_PREP_FINISHED)
    while (getRoundNumber() <= GameRunner._ROUND_COUNT) do
        GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.OBSTACLE_CHOICE_TIMEOUT)
        GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.OBSTACLE_PLACEMENT_TIMEOUT)
        Utils.logInfo("WAITING FOR OBSTACLE RUN TO COMPLETE...")
        wait(10)
        setRoundNumber(getRoundNumber() + 1)
        if (getRoundNumber() <= GameRunner._ROUND_COUNT) then
            GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.OBSTACLE_RUN_TIMEOUT)
        else
            break
        end
    end
    teardown()
    GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.GAME_FINISHED)
end

GameRunner.noOneInProgress = function()
    GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.OBSTACLE_RUN_NO_ONE_IN_PROGRESS)
end

GameRunner.incrementRoundScore = function(player, increment)
    local playerState = getActivePlayers()[player.Name]
    if (playerState == nil) then
        Utils.logError(player.Name .. " is not active: "..Utils.tableToString(getActivePlayers():GetChildren()))
    else
        playerState.CurrentRoundScore.Value = playerState.CurrentGameScore.Value + increment
        Utils.logInfo("Incremented "..player.Name.."'s score by "..Utils.truncateNumber(increment)..", now "..Utils.truncateNumber(playerState.CurrentRoundScore.Value))
    end
end

return GameRunner
