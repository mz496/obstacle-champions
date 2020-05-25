local GameLifecycleManager = require(script.Parent.GameLifecycleManager)
local State = require(game.ServerScriptService.Server.State)
local Event = require(game.ServerScriptService.Server.Event)
local StateTransition = require(game.ServerScriptService.Server.StateTransition)
local StateTransitionTable = require(game.ServerScriptService.Server.StateTransitionTable)

return function()
    describe("state tests", function()
        it("should assert that states with the same name are equal", function()
            local a1 = State("A")
            local a2 = State("A")
            expect(a1).to.equal(a2)
        end)
        it("should assert that states with different names are unequal", function()
            local a1 = State("A")
            local a2 = State("B")
            expect(a1).never.to.equal(a2)
        end)
    end)

    local transitionCount = 1
    local transitions = StateTransitionTable({
        StateTransition(State("A"), State("B"), {Event("AB")}),
        StateTransition(State("B"), State("C"), {Event("BC")})
    })
    local manager = GameLifecycleManager:init(State("A"), transitions,
        function(from, to)
            transitionCount = transitionCount+1
            print("TEST: "..tostring(transitionCount).." "..tostring(from).."->"..tostring(to))
        end)

    describe("advance state", function()
        it("should advance the state upon specified event", function()
            expect(manager:getCurrentState():getName():match("A")).to.be.ok()
            manager:acceptEvent(Event("AB"))
            expect(transitionCount).to.equal(2)
            expect(manager:getCurrentState():getName():match("B")).to.be.ok()
            manager:acceptEvent(Event("AB"))
            expect(transitionCount).to.equal(2)
            expect(manager:getCurrentState():getName():match("B")).to.be.ok()
            manager:acceptEvent(Event("BC"))
            expect(transitionCount).to.equal(3)
            expect(manager:getCurrentState():getName():match("C")).to.be.ok()
        end)
    end)
end
