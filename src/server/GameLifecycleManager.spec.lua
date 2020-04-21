local GameLifecycleManager = require(script.Parent.GameLifecycleManager)
local GameLifecycleConstants =
require(game.ServerScriptService.Server.Constants.GameLifecycle)
local States = GameLifecycleConstants.States
local Events = GameLifecycleConstants.Events

return function()
    local manager = GameLifecycleManager:new()

    describe("advance state", function()
        it("should advance the state upon specified event", function()
            expect(manager:getCurrentState():getName():match("Start")).to.be.ok()
            manager:acceptEvent(Events.WIN)
            expect(manager:getCurrentState():getName():match("End")).to.be.ok()
        end)
    end)
end

