local State =
require(game.ServerScriptService.Server.State)
local Event =
require(game.ServerScriptService.Server.Event)

local GameLifecycle = {}
local States = {}
local Events = {}

States.START = State("Start")
States.START.execute = function(self)
    Utils.logInfo("start state")
end
States.END = State("End")
States.END.execute = function(self)
    Utils.logInfo("end state")
end
States.TIE = State("Tie")
States.TIE.execute = function(self)
    Utils.logInfo("tie state")
end

Events.WIN = Event("Win")
Events.TIE = Event("Tie")
Events.LOSS = Event("Loss")

GameLifecycle.States = States
GameLifecycle.Events = Events
return GameLifecycle

