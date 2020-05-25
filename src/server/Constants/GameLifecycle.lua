local State = require(game.ServerScriptService.Server.State)
local Event = require(game.ServerScriptService.Server.Event)

local GameLifecycle = {}
local States = {}
local Events = {}

States.WAITING_TO_START = State("WaitingToStart")
States.WAITING_TO_START.execute = function(self)
    Utils.logInfo("waiting to start game state")
end
States.GAME_PREP = State("GamePrep")
States.GAME_PREP.execute = function(self)
    Utils.logInfo("start game prep state")
end
States.OBSTACLE_CHOICE = State("ObstacleChoice")
States.OBSTACLE_CHOICE.execute = function(self)
    Utils.logInfo("obstacle choice state")
end
States.OBSTACLE_PLACEMENT = State("ObstaclePlacement")
States.OBSTACLE_PLACEMENT.execute = function(self)
    Utils.logInfo("obstacle placement state")
end
States.OBSTACLE_RUN = State("ObstacleRun")
States.OBSTACLE_RUN.execute = function(self)
    Utils.logInfo("obstacle run state")
end
States.OBSTACLE_RUN_ROUND_END = State("ObstacleRunIntermediateScore")
States.OBSTACLE_RUN_ROUND_END.execute = function(self)
    Utils.logInfo("obstacle run intermediate score state")
end
States.GAME_END = State("GameEnd")
States.GAME_END.execute = function(self)
    Utils.logInfo("end game state")
end

Events.GAME_PREP_INITIATED = Event("GamePrepInitiated")
Events.GAME_PREP_FINISHED = Event("GamePrepFinished")
Events.OBSTACLE_CHOICE_TIMEOUT = Event("ObstacleChoiceTimeout")
Events.OBSTACLE_PLACEMENT_TIMEOUT = Event("ObstaclePlacementTimeout")
Events.OBSTACLE_RUN_TIMEOUT = Event("ObstacleRunTimeout")
Events.OBSTACLE_RUN_NO_ONE_IN_PROGRESS = Event("ObstacleRunNoOneInProgress")
Events.GAME_FINISHED = Event("GameFinished")

GameLifecycle.States = States
GameLifecycle.Events = Events
return GameLifecycle
