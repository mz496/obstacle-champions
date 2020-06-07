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
        StateTransition(States.OBSTACLE_RUN, States.OBSTACLE_RUN_ROUND_END, {Events.OBSTACLE_RUN_TIMEOUT, Events.OBSTACLE_RUN_NO_ONE_IN_PROGRESS}),
        StateTransition(States.OBSTACLE_RUN_ROUND_END, States.OBSTACLE_CHOICE, {Events.ROUND_CLEANUP_FINISHED}),
        StateTransition(States.OBSTACLE_RUN_ROUND_END, States.GAME_END, {Events.GAME_FINISHED})
        -- TODO event sequence needs more testing
    })

local setGameInProgress = function(bool) game.ServerStorage.State.IsGameInProgress.Value = bool end
local getGameInProgress = function() return game.ServerStorage.State.IsGameInProgress.Value end
local getActivePlayers = function() return game.ServerStorage.State.ActivePlayers end
local getQueuedPlayers = function() return game.ServerStorage.State.QueuedPlayers end
local getRoundNumber = function() return game.ServerStorage.State.RoundNumber.Value end
local setRoundNumber = function(int) game.ServerStorage.State.RoundNumber.Value = int end
local onTransition = function(from, to)
    -- TODO: remove?
end

GameRunner.addQueuedPlayer = function(player)
    Utils.logInfo("Queueing player to upcoming game " .. player.Name)
    local playerValue = PlayerState(player.Name, 0, 0, true):toValue()
    playerValue.Parent = getQueuedPlayers()
end

GameRunner.removeQueuedPlayer = function(player)
    Utils.logInfo("Removing queued player from upcoming game " .. player.Name)
    local playerValue = getQueuedPlayers()[player.Name]
    if (playerValue == nil) then
        Utils.logInfo(player.Name .. " was not queued")
    else
        playerValue.Parent = nil
        playerValue:Destroy()
        playerValue = nil
    end
end

GameRunner.removeActivePlayer = function(player)
    if (not game.ServerStorage.State.IsGameInProgress.Value) then
        Utils.logWarn("Game not in progress, can't remove " .. player.Name)
    else
        Utils.logInfo("Removing active player from game " .. player.Name)
        -- TODO: Persist player's current score
        local playerValue = getActivePlayers()[player.Name]
        if (playerValue == nil) then
            Utils.logInfo(player.Name .. " was not active")
        else
            playerValue.Parent = nil
            playerValue:Destroy()
            playerValue = nil
        end
    end
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

GameRunner.onPlayerDied = function(player)
    local playerState = getActivePlayers()[player.Name]
    if (playerState == nil) then
        Utils.logError(player.Name.." is not active: "..Utils.tableToString(getActivePlayers():GetChildren()))
    else
        playerState.IsAlive.Value = false
        Utils.logInfo("Set "..player.Name.." isAlive to "..Utils.toStringBoolean(isAlive))
        -- Check whether anyone is still in progress
        for _, playerState in pairs(getActivePlayers():GetChildren()) do
            if (playerState.IsAlive.Value) then
                Utils.logInfo(playerState.Name.." is still alive, not ending early")
                return
            end
        end
        Utils.logInfo("No one in progress, ending round early")
        GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.OBSTACLE_RUN_NO_ONE_IN_PROGRESS)
    end
end

States.GAME_PREP.execute = function(self)
    Utils.logInfo("Game prep state: set game in progress to true, move queued players to active")
    setGameInProgress(true)
    Utils.logDebug("queued="..Utils.tableToString(game.ServerStorage.State.QueuedPlayers:GetChildren())..", active="..Utils.tableToString(game.ServerStorage.State.ActivePlayers:GetChildren()))
    for _, playerState in pairs(getQueuedPlayers():GetChildren()) do
        playerState.Parent = getActivePlayers()
    end
    Utils.logDebug("queued="..Utils.tableToString(game.ServerStorage.State.QueuedPlayers:GetChildren())..", active="..Utils.tableToString(game.ServerStorage.State.ActivePlayers:GetChildren()))
    GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.GAME_PREP_FINISHED)
end

States.OBSTACLE_CHOICE.execute = function(self)
    Utils.logInfo("Starting obstacle choice for round "..Utils.truncateNumber(getRoundNumber())..", resetting isAlive state for all active players")
    for _, playerState in pairs(getActivePlayers():GetChildren()) do
        playerState.IsAlive.Value = true
    end
    wait(0.5)
    GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.OBSTACLE_CHOICE_TIMEOUT)
end

States.OBSTACLE_PLACEMENT.execute = function(self)
    Utils.logInfo("Starting obstacle placement")
    wait(0.5)
    GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.OBSTACLE_PLACEMENT_TIMEOUT)
end

States.OBSTACLE_RUN.execute = function(self)
    Utils.logInfo("WAITING FOR OBSTACLE RUN TO COMPLETE...")
    wait(10)
    GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.OBSTACLE_RUN_TIMEOUT)
end

States.OBSTACLE_RUN_ROUND_END.execute = function(self)
    local roundNumber = getRoundNumber()
    Utils.logInfo("Cleaning up after round "..Utils.truncateNumber(roundNumber))
    wait(0.5)
    if (roundNumber >= GameRunner._ROUND_COUNT) then
        GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.GAME_FINISHED)
    else
        setRoundNumber(roundNumber + 1)
        GameRunner._GAME_LIFECYCLE_MANAGER:acceptEvent(Events.ROUND_CLEANUP_FINISHED)
    end
end

States.GAME_END.execute = function(self)
    Utils.logInfo("Game end state: set game in progress to false")
    setGameInProgress(false)
end


return GameRunner
