local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local ModelPreview = require(script.Parent:WaitForChild("ModelPreview"))
local RotateDirection = require(script.Parent:WaitForChild("RotateDirection"))

local Rotate = {}

Rotate.INPUTS = {
    [Enum.KeyCode.Q.Name] = RotateDirection("AnticlockwiseAboutY",
        CFrame.Angles(0, math.rad(90), 0)),
    [Enum.KeyCode.E.Name] = RotateDirection("ClockwiseAboutY",
        CFrame.Angles(0, math.rad(-90), 0)),
    [Enum.KeyCode.R.Name] = RotateDirection("AnticlockwiseAboutX",
        CFrame.Angles(math.rad(90), 0, 0)),
    [Enum.KeyCode.F.Name] = RotateDirection("ClockwiseAboutX",
        CFrame.Angles(math.rad(-90), 0, 0)),
    [Enum.KeyCode.T.Name] = RotateDirection("AnticlockwiseAboutZ",
        CFrame.Angles(0, 0, math.rad(90))),
    [Enum.KeyCode.G.Name] = RotateDirection("ClockwiseAboutZ",
        CFrame.Angles(0, 0, math.rad(-90))),
    [Enum.KeyCode.X.Name] = RotateDirection("Placeholder",
        CFrame.Angles(0, 0, 0)),
}

Rotate.inputBegan = function(input, gameProcessedEvent)
    local rotateDirectionObject = Rotate.INPUTS[input.KeyCode.Name]
    if (not rotateDirectionObject:getIsActive()) then
        Utils.logDebug("Rotate discarding routed input " .. input.KeyCode.Name .. " because the rotation direction is not active")
        return
    end
    Utils.logDebug("Applying rotation direction: " .. rotateDirectionObject:getName())
    ModelPreview.setPreviewCFrameAnglesOnly(ModelPreview.getPreviewCFrame() * rotateDirectionObject:getTransformation())
end

Rotate.inputEnded = function(input, gameProcessedEvent)
    return
end

-- TODO: Eventually this will accept arguments e.g. obstacle type, which tell it which inputs to activate/deactivate
Rotate.activateInputs = function()
    local toActivate = {
        Enum.KeyCode.Q.Name,
        Enum.KeyCode.E.Name,
        Enum.KeyCode.R.Name,
        Enum.KeyCode.F.Name,
        Enum.KeyCode.T.Name,
        Enum.KeyCode.G.Name,
    }
    for _,key in pairs(toActivate) do
        Rotate.INPUTS[key]:setIsActive(true)
    end
end

Rotate.deactivateAllInputs = function()
    for _,rotateDir in pairs(Rotate.INPUTS) do
        rotateDir:setIsActive(false)
    end
end

return Rotate
