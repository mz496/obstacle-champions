local Event = require(script.Parent.Event)
local State = require(script.Parent.State)
local GameLifecycleManager = require(script.Parent.GameLifecycleManager)

return function()
    local manager = GameLifecycleManager:new()

    describe("advance state", function()
        it("should advance the state upon specified event", function()
            -- TODO: Move these events to a shared datamodel
            local STATE_START = State("Start")
            local STATE_TIE = State("Tie")
            local STATE_END = State("End")
            local EVENT_WIN = Event:new("Win")
            local EVENT_TIE = Event:new("Tie")
            local EVENT_LOSS = Event:new("Loss")

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

