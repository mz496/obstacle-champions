return function()
    local Greeter = require(script.Parent.Greeter)

    describe("greet", function()
        it("should include the greeting", function()
            local greeting = Greeter:greet("X")
            expect(greeting:match("Hello")).to.be.ok()
        end)
    end)
end

