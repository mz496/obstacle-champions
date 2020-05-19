local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local ModelPreview = require(script.Parent.ModelPreview)
local ManipulateDirection = require(script.Parent.ManipulateDirection)
local Manipulate = {}

Manipulate.INPUTS = {
    [Enum.KeyCode.Q.Name] = ManipulateDirection("AnticlockwiseAboutY",
        CFrame.Angles(0, math.rad(90), 0)),
    [Enum.KeyCode.E.Name] = ManipulateDirection("ClockwiseAboutY",
        CFrame.Angles(0, math.rad(-90), 0)),
    [Enum.KeyCode.R.Name] = ManipulateDirection("AnticlockwiseAboutX",
        CFrame.Angles(math.rad(90), 0, 0)),
    [Enum.KeyCode.F.Name] = ManipulateDirection("ClockwiseAboutX",
        CFrame.Angles(math.rad(-90), 0, 0)),
    [Enum.KeyCode.T.Name] = ManipulateDirection("AnticlockwiseAboutZ",
        CFrame.Angles(0, 0, math.rad(90))),
    [Enum.KeyCode.G.Name] = ManipulateDirection("ClockwiseAboutZ",
        CFrame.Angles(0, 0, math.rad(-90))),
    [Enum.KeyCode.X.Name] = ManipulateDirection("Placeholder",
        CFrame.Angles(0, 0, 0)),
}

Manipulate.inputBegan = function(input, gameProcessedEvent)
    local rotateDirectionObject = Manipulate.INPUTS[input.KeyCode.Name]
    if (not rotateDirectionObject:getIsActive()) then
        Utils.logDebug("Manipulate discarding routed input " .. input.KeyCode.Name .. " because the rotation direction is not active")
        return
    end
    Utils.logDebug("Applying rotation direction: " .. rotateDirectionObject:getName())
    ModelPreview.setPreviewCFrame(ModelPreview.getPreviewCFrame() * rotateDirectionObject:getTransformation())
end

Manipulate.inputEnded = function(input, gameProcessedEvent)
    return
end

-- TODO: Eventually this will accept arguments e.g. obstacle type, which tell it which inputs to activate/deactivate
Manipulate.activateInputs = function()
    local toActivate = {
        Enum.KeyCode.Q.Name,
        Enum.KeyCode.E.Name,
        Enum.KeyCode.R.Name,
        Enum.KeyCode.F.Name,
        Enum.KeyCode.T.Name,
        Enum.KeyCode.G.Name,
    }
    for _,key in pairs(toActivate) do
        Manipulate.INPUTS[key]:setIsActive(true)
    end
end

Manipulate.deactivateAllInputs = function()
    for _,rotateDir in pairs(Manipulate.INPUTS) do
        rotateDir:setIsActive(false)
    end
end

return Manipulate
