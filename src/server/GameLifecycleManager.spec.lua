local GameLifecycleManager = require(script.Parent.GameLifecycleManager)
local States, Events = require(game.ServerScriptService.Server.Constants.GameLifecycle)

return function()
    local manager = GameLifecycleManager:new()

    describe("advance state", function()
        it("should advance the state upon specified event", function()

            expect(manager:getCurrentState():getName():match("Start")).to.be.ok()
        end)
    end)

    --[[
    describe("greet", function()
        it("should include the greeting", function()
            local greeting = Greeter:greet("X")
            expect(greeting:match("Hello")).to.be.ok()
        end)
    end)
    ]]
end

