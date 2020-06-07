local State = require(game.ServerScriptService.Server.State)
local Event = require(game.ServerScriptService.Server.Event)
local Utils = require(game.ReplicatedStorage.Scripts.Utils)

local GameLifecycle = {}
local States = {}
local Events = {}

States.WAITING_TO_START = State("WaitingToStart")
States.GAME_PREP = State("GamePrep")
States.OBSTACLE_CHOICE = State("ObstacleChoice")
States.OBSTACLE_PLACEMENT = State("ObstaclePlacement")
States.OBSTACLE_RUN = State("ObstacleRun")
States.OBSTACLE_RUN_ROUND_END = State("ObstacleRunRoundEnd")
States.GAME_END = State("GameEnd")

Events.GAME_PREP_INITIATED = Event("GamePrepInitiated")
Events.GAME_PREP_FINISHED = Event("GamePrepFinished")
Events.OBSTACLE_CHOICE_TIMEOUT = Event("ObstacleChoiceTimeout")
Events.OBSTACLE_PLACEMENT_TIMEOUT = Event("ObstaclePlacementTimeout")
Events.OBSTACLE_RUN_TIMEOUT = Event("ObstacleRunTimeout")
Events.OBSTACLE_RUN_NO_ONE_IN_PROGRESS = Event("ObstacleRunNoOneInProgress")
Events.ROUND_CLEANUP_FINISHED = Event("RoundCleanupFinished")
Events.GAME_FINISHED = Event("GameFinished")

GameLifecycle.States = States
GameLifecycle.Events = Events
return GameLifecycle
